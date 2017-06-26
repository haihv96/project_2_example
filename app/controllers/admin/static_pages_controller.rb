class Admin::StaticPagesController < ApplicationController
  before_action :authenticate_admin

  protected

  def authenticate_admin
    render_404 unless current_user.try(:admin?)
  end
end
