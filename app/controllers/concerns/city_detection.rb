module CityDetection
  extend ActiveSupport::Concern

  private

  def require_city!
    @city = get_city_from_params ||
      get_city_from_visit ||
      get_city_from_current_person
    return if @city.present?

    respond_to_city_not_found
  end

  def get_city_from_params
    City.find_by_id(params[:city_id]) || City.find_by_slug(params[:city_slug])
  end

  def get_city_from_visit
    return unless current_visit&.city.present?

    city = City.find_or_initialize_by(name: current_visit.city)
    return city if city.persisted?

    city.attributes = build_city_attributes_from_visit(current_visit)
    return city if city.valid?

    nil
  end

  def get_city_from_current_person
    Current.person.city
  end

  def respond_to_city_not_found
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

  def get_city_name_from_query(query)
    local_guide.detect_city(query)["city"]
  end

  def local_guide
    @local_guide ||= OpenAI::Assistants::LocalGuide.new
  end

  def build_city_attributes_from_visit(visit)
    {
      time_zone: visit.time_zone,
      country_code: visit.country,
      currency: City::Currency::COUNTRY_CODE_TO_CURRENCY[visit.country] || City::Currency::FALLBACK_CURRENCY,
      lat: visit.latitude,
      lon: visit.longitude
    }
  end
end
