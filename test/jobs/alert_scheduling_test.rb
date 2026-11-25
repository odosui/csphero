require "test_helper"

class AlertSchedulingTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  setup do
    @website = create_account
    @quiet = create_account(email: "quiet@example.com", domain: "quiet.org")
  end

  test "new-violation alerts are checked for websites with unnotified violations" do
    create_violation(@website)
    create_violation(@quiet, notified_at: Time.current)

    ScheduleNewViolationAlertsJob.perform_now

    assert_enqueued_jobs 1, only: NewViolationAlertJob
    assert_enqueued_with job: NewViolationAlertJob, args: [@website]
  end

  test "weekly digests go to websites that got reports this week" do
    create_report(@website)
    create_report(@quiet, created_at: 10.days.ago)

    ScheduleWeeklyDigestsJob.perform_now

    assert_enqueued_jobs 1, only: WeeklyDigestJob
    assert_enqueued_with job: WeeklyDigestJob, args: [@website]
  end

  test "websites with the digest turned off are skipped" do
    create_report(@website)
    @website.update!(weekly_digest: false)

    ScheduleWeeklyDigestsJob.perform_now

    assert_no_enqueued_jobs only: WeeklyDigestJob
  end

  test "the digest job sends one email" do
    create_report(@website)

    assert_emails(1) { WeeklyDigestJob.perform_now(@website) }
  end

  test "the digest job sends nothing to unconfirmed addresses" do
    create_report(@website)
    User.update_all(confirmed_at: nil)

    assert_no_emails { WeeklyDigestJob.perform_now(@website) }
  end
end
