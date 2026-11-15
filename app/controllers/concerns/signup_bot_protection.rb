module SignupBotProtection
  extend ActiveSupport::Concern

  HONEYPOT_FIELD = :company_website
  TIMER_FIELD = :form_token

  included do
    rate_limit to: 5, within: 1.hour, only: :create
    before_action :drop_bot_signup, only: :create
    helper_method :signup_form_token
  end

  private

  def signup_form_token
    SignupFormTimer.issue
  end

  def drop_bot_signup
    reason = bot_signup_reason
    return unless reason

    Rails.logger.info("[signup] dropped bot signup: #{reason}")
    set_flash_message!(:notice, :signed_up_but_unconfirmed)
    redirect_to after_inactive_sign_up_path_for(resource_name)
  end

  def bot_signup_reason
    if params[HONEYPOT_FIELD].present?
      "honeypot"
    elsif !SignupFormTimer.filled_by_human?(params[TIMER_FIELD])
      "timer"
    end
  end
end
