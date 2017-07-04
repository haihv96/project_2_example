module ResourceUser
  extend ActiveSupport::Concern

  def resource
    @user ||= build_resource
  end

  def build_resource
    (user = User.find_by id: params[:id]) ? user : render_404
  end
end
