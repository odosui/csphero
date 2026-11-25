require "test_helper"

class CurrentUserApiTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    Rails.application.reload_routes_unless_loaded
    @user = User.create!(email: "owner@example.com", password: "password123", confirmed_at: Time.current)
    @user.companies.first.websites.create!(domain: "acme.org").reports.create!
    sign_in @user
  end

  test "reports how much of the monthly quota is used" do
    with_env("REPORTS_MONTHLY_QUOTA" => "500") do
      get "/api/users/me"
    end

    quota = response.parsed_body.dig("companies", 0, "report_quota")
    assert_equal 500, quota["limit"]
    assert_equal 1, quota["used"]
    assert quota["resets_at"].present?
  end

  test "reports no limit when the quota is not configured" do
    with_env("REPORTS_MONTHLY_QUOTA" => nil) do
      get "/api/users/me"
    end

    assert_nil response.parsed_body.dig("companies", 0, "report_quota", "limit")
  end
end
