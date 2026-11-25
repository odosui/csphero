require "test_helper"

class ViolationTest < ActiveSupport::TestCase
  setup do
    @website = create_account
  end

  test "the first report of a kind creates a violation" do
    report = create_report(@website)

    assert_difference -> { @website.violations.count }, 1 do
      Violation.record(report)
    end

    violation = @website.violations.sole
    assert_equal "script-src", violation.directive
    assert_equal "https://cdn.example.com", violation.blocked_source
    assert_equal 1, violation.reports_count
    assert_equal report.created_at, violation.first_seen_at
    assert_nil violation.notified_at
  end

  test "more reports of the same kind are counted, not duplicated" do
    Violation.record(create_report(@website, blocked_uri: "https://cdn.example.com/a.js", created_at: 2.days.ago))
    Violation.record(create_report(@website, blocked_uri: "https://cdn.example.com/b.js?v=3"))

    violation = @website.violations.sole
    assert_equal 2, violation.reports_count
    assert_in_delta 2.days.ago, violation.first_seen_at, 5.seconds
    assert_in_delta Time.current, violation.last_seen_at, 5.seconds
  end

  test "another directive or source is another violation" do
    Violation.record(create_report(@website))
    Violation.record(create_report(@website, directive: "img-src"))
    Violation.record(create_report(@website, blocked_uri: "https://other.example.com/a.js"))

    assert_equal 3, @website.violations.count
  end

  test "the same violation on another website is tracked separately" do
    other = create_account(email: "other@example.com", domain: "other.org")
    Violation.record(create_report(@website))
    Violation.record(create_report(other))

    assert_equal 1, @website.violations.count
    assert_equal 1, other.violations.count
  end

  test "reports caused by browser extensions are not tracked" do
    Violation.record(create_report(@website, source_file: "chrome-extension"))

    assert_empty @website.violations
  end
end
