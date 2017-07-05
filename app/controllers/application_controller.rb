class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  include CommentsHelper

  def render_404_page
    (render file: "#{Rails.root}/public/404.html", layout: false,
      status: 404) && return
  end
end
