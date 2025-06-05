class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Flash

  before_action :set_current_person
  before_action :set_sentry_user_context, if: :signed_in?

  private

  def set_current_person
    Current.person = Current.user || Current.visitor
  end

  def set_sentry_user_context
    Sentry.set_user({ id: Current.user.id })
  end

  def require_city!
    return if Current.person&.city_id&.present?

    city_name = current_visit&.city ||
      request.env["HTTP_CF_IPCITY"] ||
      request.location&.city

    if city_name.present?
      city = City.find_by(name: city_name)
      if city.present?
        Current.person.update(city: city)
        return
      end
    end

    respond_to do |format|
      format.html do
        if signed_in?
          redirect_to(edit_current_user_path)
        else
          redirect_to(edit_current_visitor_path)
        end
      end
      format.turbo_stream do
        flash.now[:error] = "Could not locate you. Please <a href=\"#{edit_current_user_path}\" class=\"link\">select a city</a>.".html_safe
        turbo_stream_flash(status: :unprocessable_entity)
      end
    end
  end
end
