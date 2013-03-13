class RoomsController < ApplicationController
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

end
