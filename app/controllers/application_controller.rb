class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Flash

  private

  def require_city!
    return if Current.user.city_id.present?

    if request.get?
      redirect_to(edit_current_user_path)
    else
      head(:unprocessable_entity)
    end
  end
end
