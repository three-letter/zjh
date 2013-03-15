#coding: utf-8
require File.expand_path("../../../lib/crypt-xxtea/poker4", __FILE__)

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
    @seat = Seat.find_by_room_id_and_user_id(@room.id, current_user.id)
    new_poker_str = params[:pokers]
    new_poker_desc = desc_poker(new_poker_str)
    old_poker_str = @room.cur_poker
    valid, compare = new_poker_desc.size > 0, 1
    if !old_poker_str.blank? && valid
      old_poker_desc = desc_poker(old_poker_str)
      compare = compare_poker(new_poker_desc, old_poker_desc)
    end
    if valid
      case compare
      when -1
        @msg = "出牌和上家不一致"
      when 0
        @msg = "出牌没上家大"
      when 1
        @next = Seat.find_by_room_id_and_seat_id(@room.id, @room.next_seat_id(@seat.seat_id))
        @pokers = new_poker_str.split(",")
        @room.cur_seat_id = @seat.seat_id
        @room.score = @room.score + poker_info(new_poker_desc)[2]
        @room.cur_poker = new_poker_str
        @room.save
        @play = 1
      end
    else
      @msg  = "出牌不符合规则"
    end
    respond_to do |format|
      format.js
    end 
  end

  private

    def fetch_room
      @room = Room.find_by_id(params[:room_id])
    end

    def desc_poker poker_str
      result = {}
      unless poker_str.blank?
        pokers = poker_str.split(",").map{|p| "#{p}"[1,"#{p}".length-1].to_i}
        poker4 = Poker4.new(pokers)
        valid = poker4.is_valid?
        if valid == 1
          sum = poker4.sum
          kind = poker4.kind
          weight = poker4.weight
          sum = 0 if poker4.is_score?
          result = {"#{kind}" => "#{weight}_#{sum}"}
        end
      end
      result
    end

    def compare_poker(new_poker, old_poker)
      new_kind, new_weight, new_sum = poker_info(new_poker)
      old_kind, old_weight, old_sum = poker_info(old_poker)
      return -1 if old_kind < 4 && new_kind < 4 && old_kind != new_kind
      new_weight > old_weight ? 1 : 0
    end

    def poker_info poker
      kind,weight,sum = poker.keys[0].to_i, poker.values[0].split("_")[0].to_i, poker.values[0].split("_")[1].to_i
    end
    
end
