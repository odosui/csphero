require "test_helper"

class MonthlyReportQuotaTest < ActiveSupport::TestCase
  setup do
    @company = Company.create!(name: "Acme")
    @website = @company.websites.create!(domain: "acme.org")
  end

  test "counts this month's reports across the company's websites" do
    other_website = @company.websites.create!(domain: "shop.acme.org")
    @website.reports.create!
    other_website.reports.create!
    @website.reports.create!(created_at: 1.month.ago)

    assert_equal 2, MonthlyReportQuota.new(@company, limit: 10).used
  end

  test "ignores other companies' reports" do
    stranger = Company.create!(name: "Stranger").websites.create!(domain: "stranger.org")
    stranger.reports.create!

    assert_equal 0, MonthlyReportQuota.new(@company, limit: 10).used
  end

  test "is exhausted once the limit is reached" do
    quota = MonthlyReportQuota.new(@company, limit: 2)

    @website.reports.create!
    assert_not quota.exhausted?

    @website.reports.create!
    assert quota.exhausted?
  end

  test "is never exhausted without a limit" do
    @website.reports.create!

    assert_not MonthlyReportQuota.new(@company, limit: nil).exhausted?
  end

  test "resets at the start of the next month" do
    travel_to Time.utc(2026, 11, 25, 12) do
      assert_equal Time.utc(2026, 12, 1), MonthlyReportQuota.new(@company).resets_at
    end
  end
end
