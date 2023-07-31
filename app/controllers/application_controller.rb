class ApplicationController < ActionController::Base
    include ActionController::MimeResponds
    
    protect_from_forgery except: :sign_in
    before_action :check_for_existing_user, only: :sign_up
    before_action :check_for_existing_user, only: :sign_in
    before_action :configure_permitted_parameters, if: :devise_controller?
    # before_action :set_current_user, if: :json_request?

    # private
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :address, :email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:role, :address, :email, :password])
        devise_parameter_sanitizer.permit(:update, keys: [:role, :address, :email, :password])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
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

    def after_sign_up_path_for(resource)
        new_user_session_path
    end
end
