class CommentsController < ApplicationController
  include ResourceComment
  authorize_resource except: :create

  def index
    comments = Post.find_by(id: params[:post_id])
               .paginate_comments params[:page]
    render json: {
      status: :success,
      html: render_to_string(partial: "paginate", layout: false,
        locals: {comments: comments})
    }
  end

  def show
    respond_to do |format|
      format.html do
        render :show
      end
      format.json do
        render json: {status: :success, object: comment}
      end
    end
  end

  def create
    authorize! :create, build_comment, message: t(".permission")
    if build_comment.save
      if params[:enter_to_comment].present?
        remember_enter_to_comment
      else
        forget_enter_to_comment
      end
      render json: {status: :success, html: render_to_string(build_comment)}
    else
      render json: {status: :error, errors: build_comment.errors.messages}
    end
  end

  def edit
    return unless request.xhr?
    render json: {
      status: :success, html: render_to_string(:edit, layout: false)
    }
  end

  def update
    if comment.update_attributes comment_params
      render json: {status: :success, message: t(".success")}
    else
      render json: {
        status: :error, errors: comment.errors.messages, message: t(".error")
      }
    end
  end

  def destroy
    if comment.destroy
      render json: {status: :success, message: t(".success")}
    else
      render json: {status: :error, message: t(".error")}
    end
  end
end
