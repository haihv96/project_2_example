module ResourcePost
  extend ActiveSupport::Concern

  included do
    before_action :build_post, only: :create
    before_action :post, except: [:create, :index]
    before_action :posts, only: :index
  end

  private

  def build_post
    @post ||= current_user.posts.build post_params
  end

  def post
    @post ||= Post.find_by(id: params[:id]) || render_404_page
  end

  def posts
    @posts = user.posts.time_line.page(params[:page])
             .per(Settings.user.posts.per_page) if user
  end

  def post_params
    params.require(:post).permit :title, :content
  end

  def user
    @user ||= User.find_by(id: params[:id]) || render_404_page
  end
end
