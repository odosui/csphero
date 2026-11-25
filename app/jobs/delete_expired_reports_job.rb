class DeleteExpiredReportsJob < ApplicationJob
  BATCH_SIZE = 10_000

  def perform
    retention_days = ReportLimits.retention_days
    return if retention_days.nil?

    Report
      .where(created_at: ...retention_days.days.ago)
      .in_batches(of: BATCH_SIZE)
      .delete_all
  end
end
