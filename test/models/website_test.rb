require "test_helper"

class WebsiteTest < ActiveSupport::TestCase
  setup do
    @website = Company.create!(name: "Acme").websites.create!(domain: "acme.org")
  end

  test "knows whether it has received any report" do
    assert_not @website.go_json[:has_reports]

    @website.reports.create!(created_at: 60.days.ago)

    assert @website.go_json[:has_reports]
  end
end
