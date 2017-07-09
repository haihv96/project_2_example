module Admin
  module ResourceUser
    extend ActiveSupport::Concern

    included do
      before_action :user, except: [:create, :index]
      before_action :users, only: :index
    end

    private

    def user
      @user ||= User.find_by(id: params[:id]) || render_404_page
    end

    def users
      @users = User.order_manager.page(params[:page])
               .per Settings.users.per_page
    end

    def user_params
      params.require(:user)
        .permit :email, :name, :phone, :birthday, :gender, :role
    end
  end
end
