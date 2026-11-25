class NewViolationAlertJob < ApplicationJob
  discard_on ActiveJob::DeserializationError

  def perform(website)
    Alerts::NewViolations.new(website).deliver
  end
end
