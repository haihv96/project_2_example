class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:relationship][:followed_id]
    if current_user.follow(@user)
      render json: {
        status: :success,
        message: "followed #{@user.full_name}",
        html: render_to_string("shared/_unfollow_form.html.erb",
          layout: false, locals: {user: @user})
      }
    else
      render json: {status: :error, message: "Can't follow this user!"}
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).try :followed
    if @user && current_user.unfollow(@user)
      render json: {
        status: :success,
        message: "unfollowed #{@user.full_name}",
        html: render_to_string("shared/_follow_form.html.erb",
          layout: false, locals: {user: @user})
      }
    else
      render json: {status: :error, message: "Can't unfollow this user!"}
    end
  end
end
