class Admin::UsersController < Admin::BaseController
  include Admin::ResourceUser

  def index
  end

  def show
    respond_to do |format|
      format.html do
        render :show
      end
      format.json do
        render json: {status: :success, object: user}
      end
    end
  end

  def update
    if user.update_attributes user_params
      render json: {
        status: :success, message: t(".success"),
        html: render_to_string(user)
      }
    else
      render json: {
        status: :error, message: t(".error"),
        errors: user.errors.messages
      }
    end
  end

  def destroy
    email = user.email
    if user.destroy
      render json: {
        status: :success, message: t(".success", email: email)
      }
    else
      render json: {
        status: :error, message: t(".error", email: email)
      }
    end
  end
end
