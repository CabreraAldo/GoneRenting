class TasksController < ApplicationController
  before_filter :get_portal

  before_filter :require_user

  def add_task
    @object = eval(params[:class_name]).find(params[:id])
    task = Task.new(params[:task])
    @object.tasks << task

    if @object.save
      @tasks = Task.find(:all, :conditions => ["portal_id = ? ",params[:id]], :order =>"created_at desc")
      flash[:notice] = 'tasks added successfully'
      render :update do |page|
        page[:show_tasks_div].replace_html :partial=> "/tasks/show_tasks"
        page[:add_tasks_div].replace_html :partial=> "/tasks/add_task"
      end
    end
  end

  def update_task
    @object = eval(params[:class_name]).find(params[:id])
    task = Task.find(params[:task_id])
    task.update_attributes(params[:task])
    @tasks = Task.find(:all, :conditions => ["portal_id = ? ",params[:id]], :order =>"created_at desc")
    flash[:notice] = 'tasks added successfully'
    render :update do |page|
      page[:show_tasks_div].replace_html :partial=> "/tasks/show_tasks"
      page[:add_tasks_div].replace_html :partial=> "/tasks/add_task"
    end

  end

  def edit
    @task = Task.find(params[:task_id])
    @object = @portal
    render :update do |page|
      page[:add_tasks_div].replace_html :partial=> "/tasks/update_task"
    end
  end

  def destroy
    task = Task.find(params[:task_id])
    @object = @portal
    if task.destroy
      @tasks = Task.find(:all, :conditions => ["portal_id = ? ",params[:id]], :order =>"created_at desc")
      flash[:notice] = 'tasks added successfully'
      render :update do |page|
        page[:show_tasks_div].replace_html :partial=> "/tasks/show_tasks"
        page[:add_tasks_div].replace_html :partial=> "/tasks/add_task"
      end
    end
  end

  def total_tasks_story
    tasks.find_all_by_taskable_id(params[:id]).count
  end

  def show_tasks
    @tempuserid = params[:user_id]
    puts "user id is ===> in show tasks ===>:#{@tempuserid}"
    puts "and object id is ===> in show tasks ===>:#{params[:id]}"
    @tasks = task.find(:all, :conditions => ["taskable_id = ?", params[:id]], :order =>"created_at desc")
    @class_name = params[:class_name]
  end

  def index
    @object = eval(params[:class_name]).find(params[:id])
    @task =task.new
    @tasks = task.find(:all, :conditions => ["taskable_id = ? AND taskable_type=?",params[:id],params[:class_name]], :order =>"created_at desc")
    @class_name = params[:class_name]
  end

  def get_portal
    @portal = Portal.find params[:id]
  end

end
