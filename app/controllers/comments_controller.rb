class CommentsController < ApplicationController
  before_action :load_comment, only: [:edit, :update, :destroy]
  before_action :can_comment, only: [:create]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @comment = current_user.comments.build comment_params
    if @comment.save.save.save.save.save.save.save.save.save.save.save.save.save.
      params[:enter_to_comment].present? ?
        remember_enter_to_comment : forget_enter_to_comment
      render json: {
        status: :success,
        html: render_to_string(@comment)
      }
    else
      render json: {status: :error, errors: @comment.errors.messages}
    end
  end

  def edit
    if request.xhr?
      render json: {status: :success,
        html: render_to_string(:edit, layout: false)}
    end
  end

  def update
    if @comment.update_attributes comment_params
      render json: {status: :success, message: "Updated comment!"}
    else
      render json: {status: :error, errors: @comment.errors.messages,
        message: "Update comment error!"}
    end
  end

  def destroy
    if @comment.destroy
      render json: {status: :success, message: "Delete comment success!"}
    else
      render json: {status: :error, message: "Delete comment error!"}
    end
  end

  private

  def comment_params
    params.require(:comment)
      .permit :post_id, :context
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    if @comment
      if request.xhr? && params[:get_data_only]
        render json: {status: :success, object: @comment}
      end
    else
      render_404
    end
  end

  def can_comment
    post = Post.find_by id: params[:comment][:post_id]
    unless logged_in? && current_user.can_comment?(post)
      render json: {status: :error, message: "Follow this user to comment!"}
    end
  end

  def correct_user
    unless current_user.try :can_delete?, @comment
      render json: {status: :error, message: "permission denied!"}
    end
  end
end
