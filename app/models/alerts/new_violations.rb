# Decides whether a website has news worth an email: violations first seen
# after its baseline period that nobody was told about yet.
class Alerts::NewViolations
  BASELINE_PERIOD = 24.hours
  MIN_INTERVAL = 1.hour

  def initialize(website)
    @website = website
  end

  def deliver
    return if learning_baseline? || recently_alerted? || pending.empty?

    send_email if @website.new_violation_alerts? && news.any? && recipients.any?
    @website.violations.where(id: pending.map(&:id)).update_all(notified_at: Time.current)
  end

  # everything a new website reports on its first day is its normal state
  def news
    pending.select { _1.first_seen_at > baseline_ends_at }
  end

  private

  def pending
    @pending ||= @website.violations.unnotified.order(reports_count: :desc).to_a
  end

  def baseline_ends_at
    @baseline_ends_at ||= @website.violations.minimum(:first_seen_at) + BASELINE_PERIOD
  end

  def learning_baseline?
    pending.any? && baseline_ends_at.future?
  end

  def recently_alerted?
    @website.alerted_at&.after?(MIN_INTERVAL.ago)
  end

  def recipients
    @website.company.alert_recipients
  end

  def send_email
    AlertMailer.new_violations(@website, news).deliver_now
    @website.update!(alerted_at: Time.current)
  end
end
