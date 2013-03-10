#coding: utf-8

class CommentsController < ApplicationController
  before_filter :fetch_cast, :except => :del 
  before_filter :authentication


  def index
    @comments = Comment.order("created_at desc").all
  end

  def create
    @comment = @cast.comments.build({cast_id: params[:cast_id], user_id: current_user.id})
    respond_to do |format|
      @join = 1 if @comment.save
      format.js
    end
  end

 def ready
   @comment = Comment.find_by_cast_id_and_user_id(params[:cast_id], @current_user.id)
   @comment.content = "1"
   respond_to do |format|
     @ready = 1 if @comment.save
     format.js
   end
 end 

  def del
    comments = Comment.all
    comments.each { |cmt| cmt.destroy}
    redirect_to root_path
  end

  private 
    def fetch_cast
      if params[:cast_id].blank?
        flash[:notice] = "该视播不存在"
        redirect_to root_path
      else
        @cast = Cast.find_by_id(params[:cast_id])
      end
    end

    def scan_user textarea
      names = textarea.scan(/@([^@]+?)\s+/).flatten
      return [] if names.size == 0
      names.delete(@current_user.name)
      @at_users = User.where(:name => names)
    end

end
