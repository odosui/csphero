# A website's last seven days in numbers, for the weekly email.
class Alerts::WeeklyDigest
  PERIOD = 7.days
  LIST_SIZE = 5

  TopViolation = Data.define(:directive, :blocked_source, :count)

  attr_reader :website

  def initialize(website, now: Time.current)
    @website = website
    @now = now
  end

  def worth_sending?
    reports_count.positive?
  end

  def reports_count
    @reports_count ||= reports_between(@now - PERIOD, @now)
  end

  def previous_reports_count
    @previous_reports_count ||= reports_between(@now - PERIOD * 2, @now - PERIOD)
  end

  def new_violations
    @new_violations ||= website.violations.first_seen_after(@now - PERIOD).order(reports_count: :desc).to_a
  end

  def top_violations
    counts_by_signature.max_by(LIST_SIZE) { |_, count| count }.map do |signature, count|
      TopViolation.new(**signature, count:)
    end
  end

  private

  def reports_between(from, to)
    website.reports.where(created_at: from...to).count
  end

  def counts_by_signature
    AggregatedReport.all(website, "7d").each_with_object(Hash.new(0)) do |aggregate, counts|
      signature = Violation::Signature.new(
        directive: aggregate.params.violated_directive,
        blocked_uri: aggregate.params.blocked_uri,
        source_file: aggregate.params.source_file
      )
      counts[signature.to_h] += aggregate.count if signature.trackable?
    end
  end
end
