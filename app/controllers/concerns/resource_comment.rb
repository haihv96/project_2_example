module ResourceComment
  extend ActiveSupport::Concern

  included do
    before_action :comment, only: [:edit, :show]
  end

  private

  def comment
    @comment ||= Comment.find_by(id: params[:id]) || render_404_page
  end

  def build_comment params = nil
    @comment ||= current_user.comments.build params
  end
end
