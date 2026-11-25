require "test_helper"

class ReportLimitsTest < ActiveSupport::TestCase
  test "there are no limits unless configured" do
    with_env("REPORTS_RETENTION_DAYS" => nil, "REPORTS_MONTHLY_QUOTA" => nil) do
      assert_nil ReportLimits.retention_days
      assert_nil ReportLimits.monthly_quota
    end
  end

  test "limits are read from the environment" do
    with_env("REPORTS_RETENTION_DAYS" => "90", "REPORTS_MONTHLY_QUOTA" => "100000") do
      assert_equal 90, ReportLimits.retention_days
      assert_equal 100_000, ReportLimits.monthly_quota
    end
  end

  test "a non-positive or garbage value means no limit" do
    with_env("REPORTS_RETENTION_DAYS" => "0", "REPORTS_MONTHLY_QUOTA" => "plenty") do
      assert_nil ReportLimits.retention_days
      assert_nil ReportLimits.monthly_quota
    end
  end
end
