class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :check_user, only: %i[index new show edit]

  def index
    # @users = User.all
    @users = User.all.includes(:tasks)
  end
  def new
    # # ログインしている時は、ユーザー登録画面に行かせないようにする
    # if logged_in?
    #   redirect_to user_path(current_user.id)
    # else
      @user = User.new
    # end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to admin_users_path, notice: 'ユーザを登録しました。'
    else
      render "admin/users/new"
    end
  end

  def show
    # 自分（current_user）以外のユーザのマイページ（userのshow画面）に行かせない
    # if current_user.id != params[:id]
      # @user = User.find(current_user.id)
    # else
      @tasks = @user.tasks.all
    # end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザー情報を更新しました！"
    else
      render "admin/users/edit"
    end
  end

  def destroy
    @tasks = Task.where(user_id: @user.id)
    @tasks.each do |n|
      n.destroy
    end

    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーが削除されました'
  end

  private

  def check_user
    if !current_user.present?
      redirect_to root_path, notice: 'アクセスできません。ログインしてください'
    elsif !current_user.admin_allowed
      redirect_to user_path(current_user.id), notice: 'アクセスできません。'
    end
  end
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
