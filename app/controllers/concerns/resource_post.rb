module ResourcePost
  extend ActiveSupport::Concern

  included do
    before_action :build_post, only: :create
    before_action :post, except: [:create, :index, :update]
    before_action :set_post, only: :update
    before_action :posts, only: :index
  end

  private

  def build_post
    unless @post
      @post = current_user.posts.build post_params
      @post.lists_tag = params[:post][:lists_tag]
    end
    @post
  end

  def post
    @post ||= Post.find_by(id: params[:id]) || render_404_page
  end

  def set_post
    post.lists_tag = params[:post][:lists_tag]
    post
  end

  def posts
    @posts = user.posts.time_line.page(params[:page])
             .per(Settings.posts.per_page) if user
  end

  def post_params
    params.require(:post).permit :lists_tag, :title, :content
  end

  def user
    @user ||= User.find_by(id: params[:id]) || render_404_page
  end
end
