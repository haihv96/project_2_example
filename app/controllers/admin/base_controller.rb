class Admin::BaseController < ApplicationController
  before_action :verify_admin
  layout "admin/layouts/admin"

  def verify_admin
    return if current_user.try :admin?
    flash[:danger] = t ".notice"
    redirect_to destroy_user_session_path
  end
end
