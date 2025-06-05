module CreditsCheck
  extend ActiveSupport::Concern

  class_methods do
    def require_credits(options = {})
      before_action :require_credits!, options
    end
  end

  private

  def require_credits!
    if Current.person.can_use_credits?
      Current.person.use_credit!
    else
      respond_to do |format|
        format.html do
          redirect_to(top_up_needed_path, status: :temporary_redirect)
        end
        format.turbo_stream do
          flash.now[:error] = "You don't have enough credits. Top up to continue."
          turbo_stream_flash(status: :payment_required)
        end
      end
    end
  end
end
