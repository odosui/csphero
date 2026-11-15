class SignupFormTimer
  MINIMUM_FILL_TIME = 3.seconds
  PURPOSE = :signup_form

  def self.issue
    verifier.generate(Time.current.to_f, purpose: PURPOSE, expires_in: 1.day)
  end

  def self.filled_by_human?(token)
    started_at = verifier.verified(token.to_s, purpose: PURPOSE)
    started_at.present? && Time.current.to_f - started_at >= MINIMUM_FILL_TIME
  end

  def self.verifier
    Rails.application.message_verifier(PURPOSE)
  end
end
