class CommentsController < ApplicationController
  before_filter :get_portal

  before_filter :require_user

  def add_comment
    @object = eval(params[:class_name]).find(params[:id])
    comment = Comment.new(params[:comment])
    @object.comments << comment

    if @object.save
      @comments = Comment.find(:all, :conditions => ["commentable_id = ? AND commentable_type=?",params[:id],params[:class_name]], :order =>"created_at desc")
      flash[:notice] = 'comments added successfully'
      render :update do |page|
        page[:show_comments_div].replace_html :partial=> "/comments/show_comments"
        page[:add_comments_div].replace_html :partial=> "/comments/add_comment"
      end
    end
  end

  def update_comment
    @object = eval(params[:class_name]).find(params[:id])
    comment = Comment.find(params[:comment_id])
    comment.update_attributes(params[:comment])    
    @comments = Comment.find(:all, :conditions => ["commentable_id = ? AND commentable_type=?",params[:id],params[:class_name]], :order =>"created_at desc")
    flash[:notice] = 'comments added successfully'
    render :update do |page|
      page[:show_comments_div].replace_html :partial=> "/comments/show_comments"
      page[:add_comments_div].replace_html :partial=> "/comments/add_comment"
    end
    
  end

  def edit
    @comment = Comment.find(params[:comment_id])
    @object = @portal
    render :update do |page|
      page[:add_comments_div].replace_html :partial=> "/comments/update_comment"
    end
  end

  def destroy
    comment = Comment.find(params[:comment_id])
    @object = @portal
    if comment.destroy
      @comments = Comment.find(:all, :conditions => ["commentable_id = ? AND commentable_type=?",params[:id],params[:class_name]], :order =>"created_at desc")
      flash[:notice] = 'comments added successfully'
      render :update do |page|
        page[:show_comments_div].replace_html :partial=> "/comments/show_comments"
        page[:add_comments_div].replace_html :partial=> "/comments/add_comment"
      end
    end
  end
  
  def total_comments_story
    Comments.find_all_by_commentable_id(params[:id]).count
  end
  
  def show_comments
    @tempuserid = params[:user_id]
    puts "user id is ===> in show comments ===>:#{@tempuserid}"
    puts "and object id is ===> in show comments ===>:#{params[:id]}"
    @comments = Comment.find(:all, :conditions => ["commentable_id = ?", params[:id]], :order =>"created_at desc")
    @class_name = params[:class_name]
  end

  def index
    @object = eval(params[:class_name]).find(params[:id])
    @tasks = Task.find_all_by_portal_id(params[:id])
    @comment =Comment.new
    @comments = Comment.find(:all, :conditions => ["commentable_id = ? AND commentable_type=?",params[:id],params[:class_name]], :order =>"created_at desc")
    @class_name = params[:class_name]
  end
  
  def get_portal
    @portal = Portal.find params[:id]
  end
end
