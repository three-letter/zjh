#coding: utf-8
require 'json'
require 'base64'
require 'net/http'
require 'digest/sha2'
require File.expand_path("../../../lib/crypt-xxtea/poker",__FILE__)


class CastsController < ApplicationController
  before_filter :authentication, :except => :set_url

  def index
    @cast = Cast.includes(:user).includes(:comments).first
  end

  def send_poker
    @cast = Cast.find_by_id(params[:cast_id])
    pokers = []
    1.upto(4) do |c|
      1.upto(13){ |n| pokers << "#{c}#{n}".to_i }
    end
    users = @cast.sort_comments.map { |cmt| cmt.user_id }
    pokers = pokers.shuffle.each_slice(3).to_a.sample(@cast.sort_comments.size())
    @cast.sort_comments.each_with_index do |cmt, index|
      pks = pokers[index]
      cmt.content = pks.join("-")
      cmt.save
    end
    @user_pokers = Hash[users.zip(pokers)]
    respond_to do |format|
      format.js
    end
  end

  def open
    all_score = params[:all_score].to_i
    score = params[:score].to_i
    @cast_id = params[:cast_id].to_i
    respond_to do |format|
      if current_user.score < score
        @open = 0
      else
        win = is_win? 
        if win
          current_user.score = current_user.score + all_score
          current_user.save
          @win_cmt = @cur_cmt
          @lose_cmt = @oth_cmt
        else
          current_user.score = current_user.score - score
          current_user.save
          @oth_cmt.user.score = @oth_cmt.user.score + all_score + score
          @oth_cmt.user.save
          @win_cmt = @oth_cmt
          @lose_cmt = @cur_cmt
        end
        @open = 1
      end
      format.js
    end
  end

  def chat
    @cast = Cast.find_by_id(params[:cast_id])
    @text = params[:chats]
    respond_to do |format|
      @msg = "消息不能为空" if @text.blank?
      format.js
    end
  end

  def new
    @cast = Cast.new
    key = gen_key
    @upload_auth   = get_upload_token
    @upload_action = gen_action key
    @upload_key = XXTEA.encrypt(XXTEA::SKEY,key)
  end

  def create
    @cast = Cast.new(params[:cast].merge(user_id: current_user.id))
    @cast.url = XXTEA.decrypt(XXTEA::SKEY,@cast.url)
    respond_to do |format|
      if @cast.save
        tagging(@cast)
        format.html {redirect_to action: "show", id: @cast.id }
      else
        @cast.url = XXTEA.encrypt(XXTEA::SKEY,@cast.url)
        format.html { render action: "new"}
      end
    end
  end

  def edit
  end

  def show
    @cast = Cast.find_by_id(params[:id])
  end

  private

    def tagging cast
      tag = cast.tag
      unless tag.blank?
        tags = tag.split("-")
        tags.each do |t|
          tag_obj = Tag.find_by_name(t.strip)
          tag_obj = Tag.create(name: t.strip) if tag_obj.blank?
          cast.tags << tag_obj

        end
      end
    end

    def is_win?
      cmts = Comment.where(:cast_id => params[:cast_id])
      @cur_cmt = cmts[0].user.id == current_user.id ? cmts[0] : cmts[1]
      cmts.delete(@cur_cmt)
      @oth_cmt = cmts[0] 
      cur_pokers = @cur_cmt.content.split("-").map { |p| [p[0].to_i, p[1,p.length].to_i == 1 ? 14 : p[1, p.length].to_i] }
      oth_pokers = @oth_cmt.content.split("-").map { |p| [p[0].to_i, p[1,p.length].to_i == 1 ? 14 : p[1, p.length].to_i] }
      cur_poker = Poker.new(cur_pokers[0][1], cur_pokers[0][0], cur_pokers[1][1], cur_pokers[1][0], cur_pokers[2][1], cur_pokers[2][0],)
      oth_poker = Poker.new(oth_pokers[0][1], oth_pokers[0][0], oth_pokers[1][1], oth_pokers[1][0], oth_pokers[2][1], oth_pokers[2][0],)
      cur_poker.weight > oth_poker.weight
    end

end
