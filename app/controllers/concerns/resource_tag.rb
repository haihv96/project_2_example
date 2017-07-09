module ResourceTag
  extend ActiveSupport::Concern

  included do
    before_action :load_posts, only: :posts
  end

  private

  def load_posts
    @tag ||= Tag.find_by(id: params[:tag_id]) || render_404_page
    @posts = @tag.posts.time_line.page(params[:page]).per Settings.posts.per_page
  end
end
