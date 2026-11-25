require "test_helper"

class ReportIngestionTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  BODY = { "csp-report" => { "violated-directive" => "script-src", "blocked-uri" => "eval" } }.to_json

  setup do
    @website = Company.create!(name: "Acme").websites.create!(domain: "acme.org")
  end

  def send_report(token = @website.token)
    post "/report/#{token}", params: BODY, headers: { "Content-Type" => "application/csp-report" }
  end

  test "stores a report and queues its processing" do
    assert_enqueued_with(job: ProcessReportJob) do
      assert_difference -> { @website.reports.count }, 1 do
        send_report
      end
    end

    assert_response :accepted
  end

  test "rejects an unknown token" do
    assert_no_difference -> { Report.count } do
      send_report("unknown")
    end

    assert_response :unprocessable_entity
  end

  test "accepts reports up to the monthly quota, then drops them" do
    with_env("REPORTS_MONTHLY_QUOTA" => "1") do
      send_report
      assert_response :accepted

      assert_no_difference -> { Report.count } do
        send_report
      end
      assert_response :too_many_requests
    end
  end

  test "accepts reports again once a new month starts" do
    with_env("REPORTS_MONTHLY_QUOTA" => "1") do
      send_report

      travel_to Time.current.next_month.beginning_of_month do
        send_report
        assert_response :accepted
      end
    end
  end
end
