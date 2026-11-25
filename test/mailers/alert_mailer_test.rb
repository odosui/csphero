require "test_helper"

class AlertMailerTest < ActionMailer::TestCase
  setup do
    @website = create_account
  end

  test "a new-violations email lists them and links to the dashboard" do
    violations = [create_violation(@website), create_violation(@website, directive: "img-src", blocked_source: "data")]

    email = AlertMailer.new_violations(@website, violations)

    assert_equal "2 new CSP violations on acme.org", email.subject
    assert_equal ["owner@example.com"], email.to
    [email.html_part, email.text_part].each do |part|
      assert_includes part.body.to_s, "https://cdn.example.com"
      assert_includes part.body.to_s, "img-src"
      assert_includes part.body.to_s, "/#/domains/#{@website.id}/agg-reports"
    end
  end

  test "a long list is cut, with the rest counted" do
    violations = 12.times.map { create_violation(@website, blocked_source: "https://cdn#{_1}.example.com") }

    email = AlertMailer.new_violations(@website, violations)

    assert_equal "12 new CSP violations on acme.org", email.subject
    assert_includes email.text_part.body.to_s, "and 2 more"
  end

  test "every alert email can be unsubscribed from in one click" do
    email = AlertMailer.new_violations(@website, [create_violation(@website)])
    url = email["List-Unsubscribe"].value[/<(.+)>/, 1]

    assert_equal "List-Unsubscribe=One-Click", email["List-Unsubscribe-Post"].value
    assert_includes email.text_part.body.to_s, url
    assert_match %r{/alerts/new_violations/unsubscribe/}, url
  end

  test "the weekly digest sums up the week" do
    3.times { create_report(@website) }
    create_violation(@website, first_seen_at: 1.day.ago)

    email = AlertMailer.weekly_digest(Alerts::WeeklyDigest.new(@website))

    assert_equal "acme.org: your week in CSP reports", email.subject
    assert_includes email.text_part.body.to_s, "3 reports"
    assert_includes email.html_part.body.to_s, "New this week"
    assert_match %r{/alerts/weekly_digest/unsubscribe/}, email["List-Unsubscribe"].value
  end
end
