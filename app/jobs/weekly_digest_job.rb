class WeeklyDigestJob < ApplicationJob
  discard_on ActiveJob::DeserializationError

  def perform(website)
    digest = Alerts::WeeklyDigest.new(website)
    return unless website.weekly_digest? && digest.worth_sending?
    return if website.company.alert_recipients.empty?

    AlertMailer.weekly_digest(digest).deliver_now
  end
end
