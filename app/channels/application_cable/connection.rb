module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Passwordless::ControllerHelpers

    attr_accessor :session

    identified_by :current_user

    def connect
      self.session = request.session
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        if verified_user = User.find_by(id: session[:user_id]) || authenticate_by_session(User)
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
