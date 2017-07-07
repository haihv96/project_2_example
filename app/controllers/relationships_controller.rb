class RelationshipsController < ApplicationController
  def create
    user =  User.find_by id: params[:relationship][:followed_id]

    if user && current_user.follow(user)
      render json: {
        status: :success,
        message: t(".followed") << user.full_name,
        html: render_to_string(partial: "shared/follow_field",
          layout: false, locals: {user: user})
      }
    else
      render json: {status: :error, message: t(".error")}
    end
  end

  def destroy
    user = Relationship.find_by(id: params[:id]).try :followed

    if user && current_user.unfollow(user)
      render json: {
        status: :success,
        message: t(".unfollowed") << user.full_name,
        html: render_to_string(partial: "shared/follow_field",
          layout: false, locals: {user: user})
      }
    else
      render json: {status: :error, message: t(".error")}
    end
  end
end
