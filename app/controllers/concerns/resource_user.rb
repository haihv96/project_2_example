module ResourceUser
  extend ActiveSupport::Concern

  included do
    before_action :user, only: :show
  end

  private

  def user
    @user ||= User.find_by(id: params[:id]) || render_404_page
  end

  def get_user_by type
    return unless user
    @users = user.send(type).page(params[:page])
             .per(Settings.users.per_page) if user
    @title = type
    render :follow
  end
end
