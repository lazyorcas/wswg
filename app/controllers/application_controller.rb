class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Flash

  private

  def require_city!
    return if Current.user.city_id.present?

    if Current.city.present?
      Current.user.update(city_id: Current.city.id)
    else
      redirect_to(edit_current_user_path)
    end
  end
end
