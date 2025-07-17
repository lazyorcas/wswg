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
      update_field_test_variant
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
    preferences_params ? preferences_params.permit(:sort_by) : {}
  end

  def update_field_test_variant
    field_test_membership = Current.person.field_test_memberships.find_by(experiment: "sort_by_interests")
    field_test_membership.update(variant: @preferences.sort_by, converted: false)
  end
end
