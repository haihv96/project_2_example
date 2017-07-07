module ResourceComment
  extend ActiveSupport::Concern

  included do
    before_action :comment, except: [:index, :create]
    before_action :build_comment, only: :create
  end

  private

  def comment
    @comment ||= Comment.find_by(id: params[:id]) || render_404_page
  end

  def build_comment
    @comment ||= current_user.comments.build comment_params
  end

  def comment_params
    params.require(:comment).permit :post_id, :content
  end
end
