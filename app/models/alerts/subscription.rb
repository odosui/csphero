# One kind of alert email for one website, addressable by a signed token so it
# can be turned off straight from the email, without signing in.
class Alerts::Subscription
  KINDS = {
    "new_violations" => { setting: :new_violation_alerts, label: "new violation alerts" },
    "weekly_digest" => { setting: :weekly_digest, label: "the weekly digest" }
  }.freeze

  attr_reader :website, :kind

  def self.find(kind, token)
    return unless KINDS.key?(kind)

    website = Website.find_signed(token, purpose: purpose(kind))
    new(website, kind) if website
  end

  def self.purpose(kind)
    "unsubscribe_#{kind}"
  end

  def initialize(website, kind)
    @website = website
    @kind = kind.to_s
  end

  def token
    website.signed_id(purpose: self.class.purpose(kind))
  end

  def label
    KINDS.fetch(kind)[:label]
  end

  def unsubscribe
    website.update!(KINDS.fetch(kind)[:setting] => false)
  end
end
