require "test_helper"

class DeleteExpiredReportsJobTest < ActiveJob::TestCase
  setup do
    website = Company.create!(name: "Acme").websites.create!(domain: "acme.org")
    @expired = website.reports.create!(created_at: 91.days.ago)
    @recent = website.reports.create!(created_at: 89.days.ago)
  end

  test "deletes reports older than the retention period" do
    with_env("REPORTS_RETENTION_DAYS" => "90") do
      DeleteExpiredReportsJob.perform_now
    end

    assert_not Report.exists?(@expired.id)
    assert Report.exists?(@recent.id)
  end

  test "keeps everything when no retention period is configured" do
    with_env("REPORTS_RETENTION_DAYS" => nil) do
      DeleteExpiredReportsJob.perform_now
    end

    assert Report.exists?(@expired.id)
  end
end
