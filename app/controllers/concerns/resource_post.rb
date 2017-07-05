module ResourcePost
  extend ActiveSupport::Concern
  include ResourceUser

  included do
    before_action :post, only: :show
    before_action :posts, only: :index
  end

  private

  def build_post params = nil
    @post ||= current_user.posts.build params
  end

  def post
    @post ||= Post.find_by(id: params[:id]) || render_404_page
  end

  def posts
    @posts ||= user.posts.time_line.page(params[:page])
               .per(Settings.posts.per_page) if user
  end
end
