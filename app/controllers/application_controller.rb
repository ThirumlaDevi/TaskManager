class ApplicationController < ActionController::Base
  include ActionController::MimeResponds

  # To avoid Cross-Site Request Forgery (CSRF)
  protect_from_forgery unless: -> { request.format.json? }
  # this is called when a CSRF token is not present or is incorrect on a non-GET request.
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    sign_out_user # Example method that will destroy the user cookies
  end
  # except: :sign_in
  before_action :check_for_existing_user, only: :sign_up
  before_action :check_for_existing_user, only: :sign_in
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :set_current_user, if: :json_request?

  # private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role address email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[role address email password])
    devise_parameter_sanitizer.permit(:update, keys: %i[role address email password])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end

  def check_for_existing_user
    # debugger
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    session[:current_user_id] = nil
  end

  def after_sign_in_path_for(resource)
    session[:current_user_id] = current_user.id
    tasks_path
  end

  # def after_sign_up_path_for(resource)
  #     new_user_session_path
  # end
end
