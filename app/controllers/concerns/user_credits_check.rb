module UserCreditsCheck
  extend ActiveSupport::Concern

  class_methods do
    def require_credits(options = {})
      before_action :require_credits!, { if: :signed_in? }.merge(options)
    end
  end

  private

  def require_credits!
    unless Current.user.can_use_credits?
      if request.get?
        redirect_to(user_no_credits_path)

      else
        flash.now[:error] = "You don't have enough credits. Top up to continue."
        render turbo_stream: turbo_stream.append("flash", partial: "shared/flash")
      end

      return
    end

    Current.user.use_credit!
  end
end
