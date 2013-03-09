#coding: utf-8

class Comment < ActiveRecord::Base
  attr_accessible :cast_id, :content, :user_id

  #validates :content, :presence => { :message => "评论不能为空" },
  #                    :length => { :maximum => 128, :message => "评论最长为128个字符" }

  belongs_to :user
  belongs_to :cast

   scope :recent_comments, lambda { |uid, limit| joins(:user).order("created_at desc").where("users.id = ?", uid).limit(limit) }

   def active
     !content.blank?
   end

   def active_msg
     if active
       "已准备"
     else
       "未准备"
     end
   end
  
   def seat
     cast.sort_comments.each_with_index do |cmt, index|
       return index if cmt.id == id
     end
   end

end
