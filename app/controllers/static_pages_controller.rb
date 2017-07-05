class StaticPagesController < ApplicationController
  def index
    page = params[:page]
    per_page = Settings.posts.per_page
    if current_user
      @posts = current_user.feed.page(page).per per_page
    else
      @posts = Post.time_line.page(page).per per_page
    end
  end
end
