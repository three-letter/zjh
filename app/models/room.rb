#coding: utf-8

class Room < ActiveRecord::Base
  attr_accessible :cur_seat_id, :score, :state, :title, :win, :style, :keep, :cur_poker
  validates :title, :presence => { :message => "标题不能为空" }

  has_many :seats

  def sort_seats
    seats.sort { |s1,s2| s1.seat_id <=> s2.seat_id }
  end

  def next_seat_id sid
    (sid + 1) == max_seat ? 0 : (sid + 1)
  end

  def seat index
    seats.select { |s| s.seat_id == index }[0]
  end

  def all_ready
    seats.size == max_seat && seats.select { |s| s.state == 1 }.size == seats.size
  end

  def state_msg
    return "游戏还未开始..." if state == 0
    return "游戏正进行中..." if state == 1
  end
  
  def has_join? 
    seats.select { |s| s.user_id == current_user.id }.size > 0
  end

  def max_seat
    return 6 if style == 1
    return 4 if style == 2
  end
  
  def tag
    return "6团" if style == 1
    return "4团" if style == 2
  end
  
  def poker_num
    return 4 if style == 1
    return 3 if style == 2
  end

  def img
    "http://ppstd.dn.qbox.me/4tuan.jpg" if style == 1
    "http://ppstd.dn.qbox.me/4tuan.jpg" if style == 2
  end

end
