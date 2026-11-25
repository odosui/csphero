require "test_helper"

class ProcessReportJobTest < ActiveJob::TestCase
  BODY = { "csp-report" => { "violated-directive" => "script-src", "blocked-uri" => "https://cdn.example.com/a.js" } }.to_json

  test "parses the report and records its violation" do
    website = create_account
    report = website.reports.create!(raw_body: BODY)

    ProcessReportJob.perform_now(report.id)

    assert_equal "script-src", report.reload.violated_directive
    assert_equal "https://cdn.example.com", website.violations.sole.blocked_source
  end
end
