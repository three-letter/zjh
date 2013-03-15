class Poker4
  attr_accessor :pokers, :sum
  
  # init the poker without color for partner
  # 3..k 1 2,the min is 3 
  def initialize(ps=[])
    @pokers = ps
    @pokers = @pokers.map do |p|
      if p > 2
        p - 2
      else
        p + 11 
      end
    end
    @sum = @pokers.inject{ |s, p| s += p }
  end

  # check the valid of pokers 
  def is_valid?
    return 0 if @pokers.size == 0
    @pokers.select{ |p| (@pokers.length == 4 && @sum != 61 ) || (p!= @pokers[0]) }.size > 0 ? 0 : 1
  end

  # chekc the score
  def is_score?
    [3,8,11].include?(@pokers[0])
  end

  # get the kind of poker
  # kind: one two three bomb 
  # bomb: four and more
  def kind
    @pokers.size > 3 ? 4 : @pokers.size
  end

  def weight
    case kind
    when 0..3
      @pokers[0] 
    when 4
      @pokers[0] * constant(@pokers.size)
    end
  end

  def constant lev
    cs = 1
    lev.times { cs = cs * 20 }
    cs
  end

end

