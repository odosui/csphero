require "test_helper"

class AlertSettingsApiTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    Rails.application.reload_routes_unless_loaded
    @website = create_account
    @user = @website.company.users.first
    sign_in @user
  end

  test "alerts are on for a new website" do
    get "/api/websites/#{@website.id}"

    assert response.parsed_body["new_violation_alerts"]
    assert response.parsed_body["weekly_digest"]
  end

  test "each kind of alert can be turned off" do
    patch "/api/websites/#{@website.id}", params: { weekly_digest: false }, as: :json

    assert_response :success
    assert_not @website.reload.weekly_digest
    assert @website.new_violation_alerts
  end

  test "nothing else about a website can be changed this way" do
    patch "/api/websites/#{@website.id}", params: { domain: "evil.org", token: "abcd1234" }, as: :json

    assert_equal "acme.org", @website.reload.domain
  end

  test "another account's website cannot be changed" do
    stranger = create_account(email: "stranger@example.com", domain: "stranger.org")

    patch "/api/websites/#{stranger.id}", params: { weekly_digest: false }, as: :json

    assert_response :not_found
    assert stranger.reload.weekly_digest
  end

  test "the current user knows whether the email is confirmed" do
    get "/api/users/me"

    assert_equal "owner@example.com", response.parsed_body["email"]
    assert response.parsed_body["confirmed"]
  end

  test "an unconfirmed user can ask for the confirmation email again" do
    @user.update_columns(confirmed_at: nil)

    assert_emails(1) { post "/api/users/resend_confirmation" }
    assert_response :no_content
  end

  test "a confirmed user gets no second confirmation email" do
    assert_no_emails { post "/api/users/resend_confirmation" }
  end
end
