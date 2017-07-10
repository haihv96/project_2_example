class SearchsController < ApplicationController
  def index
    return unless params[:search][:type] == "users"
    keyword = "%#{params[:search][:keyword]}%"
    @users = User.search keyword

    if request.xhr?
      @users = @users.limit Settings.users.limit
    else
      @users = @users.page(params[:page]).per Settings.users.per_page
    end
    @keyword = params[:search][:keyword]
    respond_to do |format|
      format.html {
        render :index
      }
      format.json {
        render json: {
          status: :success,
          html: render_to_string("shared/_users_json.html.erb", layout: false)
        }
      }
    end
  end
end
