require "test_helper"

class Alerts::WeeklyDigestTest < ActiveSupport::TestCase
  setup do
    @website = create_account
  end

  def digest
    Alerts::WeeklyDigest.new(@website)
  end

  test "compares this week's reports with the week before" do
    2.times { create_report(@website, created_at: 1.day.ago) }
    create_report(@website, created_at: 10.days.ago)
    create_report(@website, created_at: 20.days.ago)

    assert_equal 2, digest.reports_count
    assert_equal 1, digest.previous_reports_count
  end

  test "is only worth sending when there were reports this week" do
    create_report(@website, created_at: 10.days.ago)
    assert_not digest.worth_sending?

    create_report(@website)
    assert digest.worth_sending?
  end

  test "lists the violations first seen this week" do
    create_violation(@website, blocked_source: "https://old.example.com", first_seen_at: 30.days.ago)
    fresh = create_violation(@website, blocked_source: "https://new.example.com", first_seen_at: 2.days.ago)

    assert_equal [fresh], digest.new_violations
  end

  test "ranks the most reported violations of the week by origin" do
    3.times { |i| create_report(@website, blocked_uri: "https://cdn.example.com/#{i}.js") }
    create_report(@website, directive: "img-src", blocked_uri: "data")
    5.times { create_report(@website, blocked_uri: "https://stale.example.com/a.js", created_at: 10.days.ago) }
    9.times { create_report(@website, blocked_uri: "https://x.example.com/a.js", source_file: "chrome-extension") }

    top = digest.top_violations

    assert_equal ["https://cdn.example.com", "data"], top.map(&:blocked_source)
    assert_equal [3, 1], top.map(&:count)
  end
end
