class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Dateful
  include Flash
end
