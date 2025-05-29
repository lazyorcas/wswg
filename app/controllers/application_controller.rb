class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Temporal
  include Flash
end
