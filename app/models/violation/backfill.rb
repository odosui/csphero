# Builds violations from the reports stored before violations were tracked.
# They are marked as notified, so nobody gets alerted about old news.
class Violation::Backfill
  def run
    now = Time.current

    grouped_reports.each do |row|
      signature = Violation::Signature.new(
        directive: row.directive, blocked_uri: row.blocked_uri, source_file: row.source_file
      )
      next unless signature.trackable?

      Violation.tally(
        row.website_id, signature,
        count: row.total, first_seen_at: row.first_seen_at, last_seen_at: row.last_seen_at, notified_at: now
      )
    end
  end

  private

  def grouped_reports
    Report
      .group(:website_id, "directive", :blocked_uri, :source_file)
      .select(
        :website_id, :blocked_uri, :source_file,
        "COALESCE(NULLIF(violated_directive, ''), effective_directive) AS directive",
        "COUNT(*) AS total", "MIN(created_at) AS first_seen_at", "MAX(created_at) AS last_seen_at"
      )
  end
end
