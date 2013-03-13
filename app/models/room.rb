#coding: utf-8

class Room < ActiveRecord::Base
  attr_accessible :cur_seat_id, :score, :state, :title, :win, :style
  validates :title, :presence => { :message => "标题不能为空" }

  has_many :seats

  def seat index
    seats.select { |s| s.seat_id == (index + 1) }[0]
  end

  def state_msg
    return "游戏还未开始..." if state == 0
    return "游戏正进行中..." if state == 1
  end
  
  def has_join? 
    seats.select { |s| s.user_id == current_user.id }.size > 0
  end

  def tag
    return "6团" if style == 1
    return "4团" if style == 2
  end
end
