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
    user_id = @user.id
    if (current_user.id == user_id) && !(params[:admin_allowed] == true)
      redirect_to edit_admin_user_path(user_id), notice: "自分の管理者権限は外すことができません。"
    else
      unless @user.update(user_params)
        redirect_to edit_admin_user_path(user_id), notice: "管理者が1人のみであるため、管理者権限を外すことができません。"
      else
        redirect_to admin_users_path, notice: "ユーザー情報を更新しました！"
      end
    end
  end

  def destroy
    user_id = @user.id
    if current_user.id == user_id
      redirect_to admin_users_path, notice: '自分のユーザー情報を削除することはできません。'
    else
      unless @user.destroy
        redirect_to admin_users_path, notice: '管理者が1人のみであるため、削除することができません。'
      else
        redirect_to admin_users_path, notice: 'ユーザーが削除されました'
      end
    end
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin_allowed)
  end
end
