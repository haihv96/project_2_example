module Admin
  module ResourceStaticPage
    extend ActiveSupport::Concern

    included do
      before_action :load_data, only: :index
    end

    private

    def load_data
      @users = User.all
      @posts = Post.all
      @comments = Comment.all
      @tags = Tag.all
    end
  end
end
