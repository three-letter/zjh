class RoomsController < ApplicationController
  before_filter :authentication, :except => :index
  
  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    respond_to do |format|
      if @room.save
        format.html { redirect_to root_path }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @room = Room.find_by_id(params[:id])
  end

  def join
    @room = Room.find_by_id(params[:id])
    @seat = @room.seats.build({user_id: current_user.id, seat_id: params[:seat_id].to_i, :state => 0})
    respond_to do |format|
      @join = 1 if @seat.save
      format.js
    end
  end

  def send_poker
    @room = Room.find_by_id(params[:id])
    pokers = get_complete_poker * @room.poker_num
    2.times { pokers.delete(516) }
    pokers = pokers.shuffle
    keep_pokers = pokers[pokers.length-3, 3]
    send_pokers = pokers[0,pokers.length-3]
    user_pokers = send_pokers.each_slice(52).to_a.map {|ps| ps.sort_by {|p| p.to_s[1,p.to_s.length].to_i } }
    seats = @room.sort_seats.map { |s| s.user.id }
    @seat_pokers = Hash[seats.zip(user_pokers)]
    @room.keep = keep_pokers.join("-")
    @room.save
    respond_to do |format|
      format.js
    end
  end

  private

    def get_complete_poker
      pokers = [515,516]
      1.upto(4) do |c|
        1.upto(13){ |n| pokers << "#{c}#{n}".to_i }
      end
      pokers
    end

end
