class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  include CommentsHelper

  rescue_from CanCan::AccessDenied do |exception|
    message = exception.message
    respond_to do |format|
      format.html do
        flash[:danger] = message
        redirect_to root_url
      end
      format.json do
        render json: {status: :error, message: message}
      end
    end
  end

  def render_404_page
    (render file: "#{Rails.root}/public/404.html", layout: false,
      status: 404) && return
  end
end
