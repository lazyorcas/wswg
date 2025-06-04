class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Flash

  private

  def require_city!
    return if Current.person&.city_id&.present?

    if request.location.present?
      city = City.find_by(name: request.location.city)
      if city.present?
        Current.person.update(city: city)
        return
      end
    end

    respond_to do |format|
      format.html do
        if signed_in?
          redirect_to(edit_current_user_path, flash: { error: "Your city could not be determined." })
        else
          redirect_to(edit_current_visitor_path, flash: { error: "Your city could not be determined." })
        end
      end
      format.turbo_stream do
        flash.now[:error] = "Your city could not be determined. Please <a href=\"#{edit_current_user_path}\" class=\"link\">select a city</a>.".html_safe
        turbo_stream_flash(status: :unprocessable_entity)
      end
    end
  end
end
