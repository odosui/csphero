require "test_helper"

class Alerts::NewViolationsTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @website = create_account
    @baseline = create_violation(@website, blocked_source: "inline", first_seen_at: 3.days.ago)
  end

  def deliver
    Alerts::NewViolations.new(@website.reload).deliver
  end

  test "emails about a violation first seen after the baseline period" do
    fresh = create_violation(@website)

    assert_emails(1) { deliver }

    email = ActionMailer::Base.deliveries.last
    assert_equal ["owner@example.com"], email.to
    assert_equal "1 new CSP violation on acme.org", email.subject
    assert_includes email.text_part.body.to_s, "https://cdn.example.com"
    assert_not_includes email.text_part.body.to_s, "inline"
    assert fresh.reload.notified_at.present?
    assert @website.reload.alerted_at.present?
  end

  test "tells about a violation only once" do
    create_violation(@website)
    deliver

    travel 2.hours do
      assert_no_emails { deliver }
    end
  end

  test "stays quiet while a new website is still building its baseline" do
    @baseline.update!(first_seen_at: 2.hours.ago)
    fresh = create_violation(@website)

    assert_no_emails { deliver }
    assert_nil fresh.reload.notified_at
  end

  test "never emails about the baseline itself" do
    assert_no_emails { deliver }
    assert @baseline.reload.notified_at.present?
  end

  test "sends at most one email per hour" do
    create_violation(@website)
    deliver
    later = create_violation(@website, blocked_source: "https://later.example.com")

    assert_no_emails { deliver }
    assert_nil later.reload.notified_at

    travel 61.minutes do
      assert_emails(1) { deliver }
    end
  end

  test "sends nothing when alerts are turned off, and does not save them up" do
    @website.update!(new_violation_alerts: false)
    fresh = create_violation(@website)

    assert_no_emails { deliver }
    assert fresh.reload.notified_at.present?
  end

  test "sends nothing to unconfirmed addresses" do
    User.update_all(confirmed_at: nil)
    create_violation(@website)

    assert_no_emails { deliver }
  end
end
