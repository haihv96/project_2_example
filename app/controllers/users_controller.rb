class UsersController < ApplicationController
  include ResourceUser

  def show
    respond_to do |format|
      format.html {
        redirect_to profile_path if current_user == resource
      }
      format.json {
        render json: {status: :success, object: resource}
      }
    end
  end
end
