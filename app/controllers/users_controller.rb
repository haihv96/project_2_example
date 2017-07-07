class UsersController < ApplicationController
  include ResourceUser

  def show
    respond_to do |format|
      format.html do
        redirect_to profile_path if user.is? current_user
      end
      format.json do
        render json: {status: :success, object: user}
      end
    end
  end

  def following
    get_user_by :following
  end

  def followers
    get_user_by :followers
  end
end
