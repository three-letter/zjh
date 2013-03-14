#coding: utf-8

class SeatsController < ApplicationController
  before_filter :fetch_room

  def start
    @seat = Seat.find_by_room_id_and_user_id(@room.id, current_user.id)
    @seat.state = 1
    respond_to do |format|
      @start = 1 if @seat.save
      format.js
    end
  end

  def play
    poker_str = params[:pokers]
    respond_to do |format|
      if poker_str.blank?
        @play = 0
        @msg  = "请选择至少一张扑克" 
      else
        @play = 1
      end
      format.js
    end 
  end

  private

    def fetch_room
      @room = Room.find_by_id(params[:room_id])
    end

end
