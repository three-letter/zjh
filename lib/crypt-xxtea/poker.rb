class Poker
  # init the poker with color for partner
  def initialize(x, c_x, y, c_y, z, c_z)
    @x, @y, @z = "#{c_x}#{x}".to_i, "#{c_y}#{y}".to_i, "#{c_z}#{z}".to_i
    @pokers ||= [] << x << y << z
    @colors ||= [] << c_x << c_y << c_z
  end

  # sort the three pokers desc without color
  def sort
    @pokers.sort.reverse
  end

  # dyn define method to get the max, mid, min of three pokers
  {"max" => 0, "min" => 1, "min" => 2}.each do |k, v|
    define_method "get_#{k}" do
      sort[v]
    end
  end

  def is_bomb?
    @pokers.join.to_i % 111 == 0
  end

  def is_straightflush?
    is_flush? && is_straight?
  end

  def is_flush?
    @colors.join.to_i % 111 == 0
  end
  
  def is_straight?
    sort[0] == (sort[1] + 1) && sort[1] == (sort[2] + 1)
  end

  def is_pair?
    !is_bomb? && (sort[0] == sort[1] || sort[1] == sort[2])
  end

  def level
    type = 0
    return type = 5 if is_bomb?
    return type = 4 if is_straightflush?
    return type = 3 if is_flush?
    return type = 2 if is_straight?
    return type = 1 if is_pair?
    return type
  end

  def weight
    case level
    when 0
      sort[0] * constant(2) + sort[1] * constant(1) + sort[2]
    when 1
      sort[1] * constant(3) + (sort[0] == sort[1] ? sort[2] : sort[0]) * constant(2)
    when 2
      sort[0] * constant(4)
    when 3
      sort[0] * constant(5) + sort[1] * constant(4) + sort[2] * constant(3)
    when 4
      sort[0] * constant(6) + sort[1] * constant(5) + sort[2] * constant(4)
    when 5
      sort[0] * constant(7)
    end
  end

  def constant lev
    cs = 1
    lev.times { cs = cs * 15 }
    cs
  end

end
