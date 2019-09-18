class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    if params[:task].present? && params[:task][:search] == "true"
      # @tasks = Task.where("name LIKE ? AND status = ?", "%#{ params[:task][:name] }%", params[:task][:status])
      @tasks = Task.search(params[:task][:name], params[:task][:status])
    else
      if params[:sort_priority]
        @order = "asc"
        @order = params[:order] if params[:order]
        @tasks = Task.all.order(priority: "desc", created_at: @order)
      elsif params[:sort_expired]
        @order = "asc"
        @order = params[:order] if params[:order]
        @tasks = Task.all.order(deadline: "desc", created_at: @order)
      else
        if params[:order] == "asc"
          @order = "desc"
        else
          @order = "asc"
        end
        @tasks = Task.all.order(created_at: @order)
      end
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.invalid?
      render :new
    else
      if @task.save
        redirect_to tasks_path, notice: 'タスクが作成されました。'
      else
        render :new
      end
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクが削除されました'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :deadline, :status, :priority)
  end
end
