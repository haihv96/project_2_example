class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :logged_in_user, except: [:new, :create, :index, :show]
  before_action :can_create, only: [:new, :create]

  def index
    @users = User.order_id.page(params[:page]).per 12
  end

  def new
    @user = User.new
  end

  def show
    @posts = @user.posts.linetime.page(params[:page]).per 5
  end

  def create
    @user = User.new user_params
    if @user.save
      render json: {status: :success, redirect_to: login_url}
    else
      render json: {status: :error, errors: @user.errors.messages}
    end
  end

  def following
    @title = "#{@user.full_name} Following"
    @users = @user.following.page(params[:page]).per 12
    render :show_follow
  end

  def followers
    @title = "Follower #{@user.full_name} "
    @users = @user.followers.page(params[:page]).per 12
    render :show_follow
  end

  private

  def user_params
    params.require(:user)
      .permit :email, :full_name, :gender, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end

  def can_create
    logged_out_user
  end
end
