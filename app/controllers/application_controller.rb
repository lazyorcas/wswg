class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Flash
end
