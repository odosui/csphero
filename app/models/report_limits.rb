# Optional caps on stored reports, set through environment variables.
# An unset (or non-positive) variable means "no limit".
module ReportLimits
  def self.retention_days
    positive_integer("REPORTS_RETENTION_DAYS")
  end

  def self.monthly_quota
    positive_integer("REPORTS_MONTHLY_QUOTA")
  end

  def self.positive_integer(name)
    value = ENV[name].to_i
    value if value.positive?
  end
  private_class_method :positive_integer
end
