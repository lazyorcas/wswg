class Home::PersonalizationController < ApplicationController
  layout "home"

  def index
    return head(:ok) if browser.bot?

    build_personalization

    if personalization_params.present?
      if @personalization.valid?
        begin
          @personalization.save!
        rescue => e
          Sentry.capture_exception(e)
        end
      end
    end

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
        flash.now[:error] = "Something went wrong. Please contact us."
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
    personalization_params ? personalization_params.permit(Personalization::FIELDS) : {}
  end
end
