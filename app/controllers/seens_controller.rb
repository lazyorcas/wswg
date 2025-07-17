class SeensController < ApplicationController
  include FieldTestHelper
  include CurrentPerson::Settings::PreferencesHelper

  def create
    ahoy.track "Viewed event", event_id: seen_params[:event_id], source: params[:source], sort_by: sort_by

    convert_field_test(:sort_by_interests)

    find_or_create_seen!
    head(:ok)
  end

  private

  def find_or_create_seen!
    seen_scope.find_or_create_by!(event_id: seen_params[:event_id])
  end

  def seen_scope
    Seen.where(seenable: Current.person)
  end

  def seen_params
    seen_params = params[:seen]
    seen_params ? seen_params.permit(:event_id) : {}
  end
end
