class SessionsController < ApplicationController
  before_action :logged_in_user, only: :destroy
  before_action :logged_out_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user

      if params[:session][:remember_me] == Settings.user.remember_me
        remember user
      else
        forget user
      end
      redirect_back_or root_url
    else
      flash.now[:danger] = "Email/password invalid"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = "Logout success"
    redirect_to login_path
  end
end

