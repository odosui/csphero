require "test_helper"

class WebsiteDeletionApiTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    Rails.application.reload_routes_unless_loaded
    @website = create_account
    sign_in @website.company.users.first
  end

  test "deleting a website removes its reports and violations" do
    create_report(@website)
    create_violation(@website)

    delete "/api/websites/#{@website.id}"

    assert_response :no_content
    assert_not Website.exists?(@website.id)
    assert_equal 0, Report.where(website_id: @website.id).count
    assert_equal 0, Violation.where(website_id: @website.id).count
  end

  test "a deleted website's endpoint stops accepting reports" do
    token = @website.token
    delete "/api/websites/#{@website.id}"

    post "/report/#{token}", params: { "csp-report" => {} }.to_json, headers: { "Content-Type" => "application/csp-report" }

    assert_response :unprocessable_entity
  end

  test "other websites of the account are left alone" do
    other = @website.company.websites.create!(domain: "other.org")
    create_report(other)

    delete "/api/websites/#{@website.id}"

    assert Website.exists?(other.id)
    assert_equal 1, other.reports.count
  end

  test "another account's website cannot be deleted" do
    stranger = create_account(email: "stranger@example.com", domain: "stranger.org")

    delete "/api/websites/#{stranger.id}"

    assert_response :not_found
    assert Website.exists?(stranger.id)
  end
end
