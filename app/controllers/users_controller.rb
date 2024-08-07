class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: 10)
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = "Not found users!"
    redirect_to root_path
  end

  def update
    if @user.update user_params
      flash[:success] = "Cap nhat thanh cong"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "User deleted"
    else
      flash[:danger] = "Delete fail!"
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @pagy, @users = pagy @user.following, items: 10
    render :show_follow
  end

  def followers
    @title = "Followers"
    @pagy, @users = pagy @user.followers, items: 10
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def find_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path unless @user
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = "Please log in."
    store_location
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = "You cannot edit this account."
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
