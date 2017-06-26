class PostsController < ApplicationController
  before_action :load_post, only: [:update, :show, :destroy, :load_comment]
  before_action :logged_in_user, except: [:index, :show, :load_comment]
  before_action :correct_user, only: [:update, :destroy]

  def index
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      render json: {
        status: :success,
        message: "Create post success!",
        html: render_to_string(@post)
      }
    else
      render json: {status: :error, errors: @post.errors.messages,
        message: "Create post error!"}
    end
  end

  def show
  end

  def update
    if @post.update_attributes post_params
      render json: {status: :success, message: "Updated post!"}
    else
      render json: {status: :error, errors: @post.errors.messages,
        message: "Update post error!"}
    end
  end

  def destroy
    if @post.destroy
      render json: {status: :success, message: "Delete post success!"}
    else
      render json: {status: :error, message: "Delete post error!"}
    end
  end

  def load_comment
    rest_comments = @post.rest_comments params[:post][:id_comment_continue]
    @comments = rest_comments.try(:limit, 5)
    if @comments
      render json: {
        status: :success,
        id_comment_continue:
          @comments.ids.present? ? @comments.last_id : 0,
        continue_loading: rest_comments.count > 5,
        html: render_to_string(@comments)
      }
    else
      render json: {status: :error}
    end
  end

  private

  def post_params
    params.require(:post)
      .permit :title, :context
  end

  def load_post
    @post = Post.find_by id: params[:id]
    if @post
      if request.xhr? && params[:get_data_only]
        render json: {status: :success, object: @post}
      end
    else
      render_404
    end
  end

  def correct_user
    unless current_user.try :is_author?, @post
      render json: {status: :error, message: "permission denied!"}
    end
  end
end
