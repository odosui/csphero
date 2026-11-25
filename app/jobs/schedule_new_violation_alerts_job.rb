class ScheduleNewViolationAlertsJob < ApplicationJob
  def perform
    Website.where(id: Violation.unnotified.select(:website_id)).find_each do |website|
      NewViolationAlertJob.perform_later(website)
    end
  end
end
