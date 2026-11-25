require "test_helper"

class Violation::BackfillTest < ActiveSupport::TestCase
  setup do
    @website = create_account
  end

  test "builds one violation per kind from stored reports" do
    create_report(@website, blocked_uri: "https://cdn.example.com/a.js", created_at: 10.days.ago)
    create_report(@website, blocked_uri: "https://cdn.example.com/b.js", created_at: 1.day.ago)
    create_report(@website, directive: "img-src", blocked_uri: "data")

    Violation::Backfill.new.run

    scripts = @website.violations.find_by!(directive: "script-src")
    assert_equal 2, @website.violations.count
    assert_equal 2, scripts.reports_count
    assert_in_delta 10.days.ago, scripts.first_seen_at, 5.seconds
    assert_in_delta 1.day.ago, scripts.last_seen_at, 5.seconds
  end

  test "marks old violations as already notified" do
    create_report(@website)

    Violation::Backfill.new.run

    assert @website.violations.sole.notified_at.present?
  end

  test "skips unparsed and extension reports" do
    @website.reports.create!
    create_report(@website, source_file: "moz-extension")

    Violation::Backfill.new.run

    assert_empty @website.violations
  end
end
