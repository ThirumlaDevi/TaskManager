class Api::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def resource_name
    :user
  end

  def respond_with(resource, _opts = {})
    if resource.id.nil?
      render json: { errors: [{ message: 'Email or password is incorrect' }]}, status: :unauthorized
    else
      render json: { message: 'You are logged in.' }, status: :ok
    end
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { errors: [{ message: 'log out failed.'}]}, status: :unauthorized
  end
end

