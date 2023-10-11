module UserConcern extend ActiveSupport::Concern
  # Instance methods of Devise that needs to be added as instance method as Devise is not direct ancestory of that class
  included do
    def authenticate_user!
      super unless session['current_user_id'].present?
    end

    def current_user_id
      session['current_user_id']
    end

    def current_user
      @current_user ||= User.find(current_user_id)
    end

    def getUserId
      current_user.id
    end
  end
end
