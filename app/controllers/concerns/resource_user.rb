module ResourceUser
  extend ActiveSupport::Concern

  included do
    before_action :user, only: :show
  end

  private

  def user
    @user ||= User.find_by(id: params[:id]) || render_404_page
  end
end
