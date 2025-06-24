class Home::PersonalizationController < ApplicationController
  include BotProtection

  layout "home"
  protect_from_bots

  def index
    build_personalization

    ahoy.track "Visited personalization page", completed: @personalization.complete?
  end

  def update
    ahoy.track "Personalized", params: personalization_params

    build_personalization
    if @personalization.valid?
      begin
        @personalization.save!
        redirect_to(personalization_path)
      rescue => e
        Sentry.capture_exception(e)
        flash.now[:error] = "Something went wrong. Please try again."
        turbo_stream_flash(status: :unprocessable_entity)
      end
    else
      turbo_stream_flash(status: :bad_request)
    end
  end

  private

  def build_personalization
    @personalization = Personalization.new(Current.person)
    @personalization.attributes = personalization_params
  end

  def personalization_params
    personalization_params = params[:personalization]
    personalization_params ? personalization_params.permit(:medium, :frequency, :email) : {}
  end
end
