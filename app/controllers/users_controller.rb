class UsersController < ApplicationController
  def new
    # ログインしている時は、ユーザー登録画面に行かせないようにする
    if logged_in?
      redirect_to user_path(current_user.id)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = user.id
      redirect_to user_path(@user.id), notice: 'ユーザを登録しました。'
    else
      render 'new'
    end
  end

  def show
    # 自分（current_user）以外のユーザのマイページ（userのshow画面）に行かせない
    if current_user.id != params[:id]
      @user = User.find(current_user.id)
    else
      @user = User.find(params[:id])
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
