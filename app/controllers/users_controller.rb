class UsersController < ApplicationController
  include ResourceUser

  def show
    respond_to do |format|
      format.html do
        redirect_to profile_path if current_user.is? user
      end
      format.json do
        render json: {status: :success, object: user}
      end
    end
  end
end
