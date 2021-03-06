class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    # ログインしていないのにタスクのページに飛ぼうとした場合は、ログインページに遷移させる
    if logged_in?
      paginates_per = 4
      if params[:task].present? && params[:task][:label_search] == "true"
        label = Label.find(params[:task][:label_id])
        @tasks = label.tasks.where(user_id: current_user.id).page(params[:page]).per(paginates_per)
      else
        @tasks = Task.where(user_id: current_user.id)

        if params[:task].present? && params[:task][:search] == "true"
          # @tasks = Task.where("name LIKE ? AND status = ?", "%#{ params[:task][:name] }%", params[:task][:status])
          @tasks = Task.search(params[:task][:name], params[:task][:status], current_user.id).page(params[:page]).per(paginates_per)
        else
          if params[:sort_priority]
            @order = "asc"
            @order = params[:order] if params[:order]
            # @tasks = Task.all.order(priority: "desc", created_at: @order).page(params[:page]).per(paginates_per)
            @tasks = @tasks.all.order(priority: "desc", created_at: @order).page(params[:page]).per(paginates_per)
          elsif params[:sort_expired]
            @order = "asc"
            @order = params[:order] if params[:order]
            # @tasks = Task.all.order(deadline: "desc", created_at: @order).page(params[:page]).per(paginates_per)
            @tasks = @tasks.all.order(deadline: "desc", created_at: @order).page(params[:page]).per(paginates_per)
          else
            if params[:order] == "asc"
              @order = "desc"
            else
              @order = "asc"
            end
            # @tasks = Task.all.order(created_at: @order)
            # @tasks = Task.page(params[:page]).per(paginates_per).order(created_at: @order)
            @tasks = @tasks.page(params[:page]).per(paginates_per).order(created_at: @order)
          end
        end
      end
    else
      redirect_to new_session_path
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
    @task.user_id = current_user.id
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
    params.require(:task).permit(:name, :description, :deadline, :status, :priority, label_ids: [])
  end
end
