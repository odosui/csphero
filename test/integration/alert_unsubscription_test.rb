require "test_helper"

class AlertUnsubscriptionTest < ActionDispatch::IntegrationTest
  setup do
    @website = create_account
  end

  def unsubscribe_path(kind)
    alert_unsubscription_path(kind:, token: Alerts::Subscription.new(@website, kind).token)
  end

  test "opening the link asks first and changes nothing" do
    get unsubscribe_path("new_violations")

    assert_response :success
    assert_select "input[type=submit][value=Unsubscribe]"
    assert @website.reload.new_violation_alerts
  end

  test "confirming turns that kind of alert off, without signing in" do
    post unsubscribe_path("new_violations")

    assert_response :success
    assert_not @website.reload.new_violation_alerts
    assert @website.weekly_digest
  end

  test "the weekly digest has its own link" do
    post unsubscribe_path("weekly_digest")

    assert_not @website.reload.weekly_digest
    assert @website.new_violation_alerts
  end

  test "a token for one kind does not work for another" do
    token = Alerts::Subscription.new(@website, "weekly_digest").token

    post alert_unsubscription_path(kind: "new_violations", token:)

    assert_response :not_found
    assert @website.reload.new_violation_alerts
  end

  test "a forged token changes nothing" do
    post alert_unsubscription_path(kind: "new_violations", token: "forged")

    assert_response :not_found
    assert @website.reload.new_violation_alerts
  end
end
