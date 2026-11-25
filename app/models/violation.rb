# A kind of CSP violation a website keeps reporting: one row per directive and
# blocked source, however many reports arrive.
class Violation < ApplicationRecord
  belongs_to :website

  COUNT_ANOTHER_REPORT = Arel.sql(<<~SQL.squish)
    reports_count = violations.reports_count + EXCLUDED.reports_count,
    first_seen_at = LEAST(violations.first_seen_at, EXCLUDED.first_seen_at),
    last_seen_at = GREATEST(violations.last_seen_at, EXCLUDED.last_seen_at)
  SQL

  scope :unnotified, -> { where(notified_at: nil) }
  scope :first_seen_after, ->(time) { where(first_seen_at: time..) }

  def self.record(report)
    signature = Signature.of(report)
    return unless signature.trackable?

    tally(report.website_id, signature, count: 1, first_seen_at: report.created_at, last_seen_at: report.created_at)
  end

  def self.tally(website_id, signature, count:, first_seen_at:, last_seen_at:, notified_at: nil)
    upsert(
      { website_id:, **signature.to_h, reports_count: count, first_seen_at:, last_seen_at:, notified_at: },
      unique_by: %i[website_id directive blocked_source],
      on_duplicate: COUNT_ANOTHER_REPORT
    )
  end
end
