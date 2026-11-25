class MonthlyReportQuota
  attr_reader :limit

  def initialize(company, limit: ReportLimits.monthly_quota)
    @company = company
    @limit = limit
  end

  def used
    @company.reports.where(created_at: Time.current.all_month).count
  end

  def exhausted?
    limit.present? && used >= limit
  end

  def resets_at
    Time.current.next_month.beginning_of_month
  end

  def go_json
    { limit:, used:, resets_at: }
  end
end
