#coding: utf-8
class Seat < ActiveRecord::Base
  attr_accessible :poker, :room_id, :score, :seat_id, :state, :user_id
  belongs_to :room
  belongs_to :user

  def active_msg
    return "未准备" if state == 0
    return "已准备" if state == 1
  end

end
