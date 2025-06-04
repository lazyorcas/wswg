module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Passwordless::ControllerHelpers

    attr_accessor :session

    identified_by :current_person

    def connect
      self.session = request.session
      self.current_person =
        find_verified_user ||
        find_verified_visitor ||
        reject_unauthorized_connection
    end

    private

    def find_verified_user
      User.find_by(id: session[:user_id]) || authenticate_by_session(User)
    end

    def find_verified_visitor
      Visitor.find_by(visitor_token: session[:visitor_token])
    end
  end
end
