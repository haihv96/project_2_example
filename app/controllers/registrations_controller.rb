class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create

  def create
    build_resource sign_up_params
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up_success
      else
        sign_up_success_but_inactive
      end
    else
      sign_up_error
    end
  end

  def update
    super do |resource|
      return if profile_account_params.present? && update_profile(resource)
    end
  end

  protected

  def sign_up_success
    sign_up resource_name, resource
    render json: {
      status: :success, message: t(".success"),
      flash: find_message(:signed_up)
    }
  end

  def sign_up_success_but_inactive
    expire_data_after_sign_in!
    render json: {
      status: :success, message: t(".success"),
      flash: find_message("signed_up_but_#{resource.inactive_message}")
    }
  end

  def sign_up_error
    clean_up_passwords resource
    set_minimum_password_length
    render json: {
      status: :error, message: t(".error"),
      errors: resource.errors
    }
  end

  def update_profile resource
    return false unless profile_account_params.present?
    respond_to do |format|
      if resource.update_attributes profile_account_params
        update_profile_success format
      else
        update_profile_error format
      end
    end
  end

  def update_profile_success format
    format.json do
      render json: {
        status: :success,
        message: t(".success")
      }
    end
    format.html do
      flash.now[:success] = t ".success_html"
      render :edit
    end
  end

  def update_profile_error format
    format.json do
      render json: {
        status: :error, message: t(".error"),
        errors: resource.errors.messages
      }
    end
    format.html do
      flash[:danger] = t ".error_html"
      redirect_to profile_path
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit :sign_up,
      keys: [:full_name, :gender, :phone]
  end

  def profile_account_params
    params[resource_name].permit :avatar_crop_x, :avatar_crop_y, :avatar_crop_w,
      :avatar_crop_h, :full_name, :gender, :phone, :avatar
  end
end
