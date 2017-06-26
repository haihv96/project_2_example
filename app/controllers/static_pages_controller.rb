class StaticPagesController < ApplicationController
  def index
    @posts = get_data
    @post = Post.new
  end

  private

  def get_data
    data = logged_in? ? current_user.feed : Post.linetime
    @users = data.page(params[:page]).per 5
  end
end
