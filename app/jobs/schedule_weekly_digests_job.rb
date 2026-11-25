class ScheduleWeeklyDigestsJob < ApplicationJob
  def perform
    recently_active = Report.where(created_at: Alerts::WeeklyDigest::PERIOD.ago..).select(:website_id)

    Website.where(weekly_digest: true, id: recently_active).find_each do |website|
      WeeklyDigestJob.perform_later(website)
    end
  end
end
