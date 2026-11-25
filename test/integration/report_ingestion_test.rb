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

  test "keeps the user agent and drops every other request header" do
    post "/report/#{@website.token}", params: BODY, headers: {
      "Content-Type" => "application/csp-report",
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0",
      "X-Forwarded-For" => "203.0.113.7",
      "Cookie" => "session=secret"
    }

    report = @website.reports.sole
    assert_equal ["HTTP_USER_AGENT"], JSON.parse(report.raw_headers).keys
    assert_not_includes report.raw_headers, "203.0.113.7"
    assert_equal "Firefox", report.user_agent_data[:family]
  end

  test "rejects an unknown token" do
    assert_no_difference -> { Report.count } do
      send_report("unknown")
    end

    assert_response :unprocessable_entity
  end

  test "answers the preflight browsers send before a Reporting API report" do
    process :options, "/report/#{@website.token}", headers: {
      "Origin" => "https://acme.org",
      "Access-Control-Request-Method" => "POST",
      "Access-Control-Request-Headers" => "content-type"
    }

    assert_response :no_content
    assert_equal "*", response.headers["Access-Control-Allow-Origin"]
    assert_includes response.headers["Access-Control-Allow-Methods"], "POST"
    assert_equal "Content-Type", response.headers["Access-Control-Allow-Headers"]
  end

  test "lets any origin read the answer to a report" do
    send_report

    assert_equal "*", response.headers["Access-Control-Allow-Origin"]
  end

  test "stores every violation of a Reporting API batch" do
    batch = [
      { type: "csp-violation", body: { effectiveDirective: "script-src-elem", blockedURL: "https://cdn.example.com/a.js" } },
      { type: "csp-violation", body: { effectiveDirective: "img-src", blockedURL: "data" } },
      { type: "deprecation", body: { id: "websql" } }
    ]

    perform_enqueued_jobs do
      post "/report/#{@website.token}", params: batch.to_json, headers: { "Content-Type" => "application/reports+json" }
    end

    assert_response :accepted
    assert_equal %w[img-src script-src-elem], @website.reports.pluck(:violated_directive).sort
  end

  test "rejects a body that is not a JSON report" do
    ["not json at all", "42", "[]"].each do |body|
      assert_no_difference -> { Report.count } do
        post "/report/#{@website.token}", params: body, headers: { "Content-Type" => "application/csp-report" }
      end
      assert_response :bad_request
    end
  end

  test "rejects an oversized body" do
    huge = { "csp-report" => { "blocked-uri" => "x" * ReportPayload::MAX_BYTES } }.to_json

    assert_no_difference -> { Report.count } do
      post "/report/#{@website.token}", params: huge, headers: { "Content-Type" => "application/csp-report" }
    end
    assert_response :bad_request
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
