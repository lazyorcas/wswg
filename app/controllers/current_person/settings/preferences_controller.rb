class CurrentPerson::Settings::PreferencesController < ApplicationController
  include FieldTestHelper
  include CurrentPerson::Settings::PreferencesHelper

  before_action :load_return_to, only: [ :update ]

  def show
    build_preferences

    ahoy.track "Viewed preference", preference: params[:id]
  end

  def update
    ahoy.track "Updated preference", preferences_params

    build_preferences

    if @preferences.save
      update_sort_by_field_test_variant if params[:sort_by].present?
      update_hide_impression_events_field_test_variant if params[:hide_impression_events].present?
      redirect_to(@return_to)
    else
      flash.now[:error] = "Failed to update preferences."
      turbo_stream_flash(status: :unprocessable_entity)
    end
  end

  private

  def load_return_to
    @return_to = URI(request.referer).path
  end

  def build_preferences
    @preferences = Current.person.settings(:preferences)
    @preferences.attributes = preferences_params
  end

  def preferences_params
    preferences_params = params[:preferences]
    preferences_params ? preferences_params.permit(:sort_by, :hide_impression_events) : {}
  end

  def update_sort_by_field_test_variant
    field_test_membership = Current.person.field_test_memberships.find_by(experiment: "sort_by_interests")
    if field_test_membership.present?
      field_test_membership.update(variant: @preferences.sort_by, converted: false)
    end
  end

  def update_hide_impression_events_field_test_variant
    field_test_membership = Current.person.field_test_memberships.find_by(experiment: "hide_impression_events")
    if field_test_membership.present?
      field_test_membership.update(variant: @preferences.hide_impression_events, converted: false)
    end
  end
end
