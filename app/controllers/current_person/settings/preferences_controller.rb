class CurrentPerson::Settings::PreferencesController < ApplicationController
  before_action :load_return_to, only: [ :update ]

  def show
    build_preferences

    ahoy.track "Viewed preference", preference: params[:id]
  end

  def update
    build_preferences

    if @preferences.save
      redirect_to(@return_to)
    else
      flash.now[:error] = "Failed to update preferences."
      turbo_stream_flash(status: :unprocessable_entity)
    end

    ahoy.track "Updated preference", params[:preferences]
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
end
