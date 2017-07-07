class PostsController < ApplicationController
  include ResourcePost
  authorize_resource

  def index
  end

  def create
    if build_post.save
      render json: {
        status: :success,
        message: t(".success"),
        html: render_to_string(build_post)
      }
    else
      render json: {
        status: :error, errors: build_post.errors.messages,
        message: t(".error")
      }
    end
  end

  def show
    respond_to do |format|
      format.html do
        render :show
      end
      format.json do
        render json: {status: :success, object: post}
      end
    end
  end

  def update
    if post.update_attributes post_params
      render json: {
        status: :success, message: t(".success")
      }
    else
      render json: {
        status: :error, errors: post.errors.messages,
        message: t(".error")
      }
    end
  end

  def destroy
    if post.destroy
      render json: {status: :success, message: t(".success")}
    else
      render json: {status: :error, message: t(".error")}
    end
  end
end
