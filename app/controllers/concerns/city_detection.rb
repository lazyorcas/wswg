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
    City.find_by_name(current_visit&.city)
  end

  def get_city_from_current_person
    Current.person&.city
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
end
