class Company < ApplicationRecord
  validates :name, presence: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :websites, dependent: :destroy
  has_many :reports, through: :websites

  # alerts only go to addresses their owners have confirmed
  def alert_recipients
    users.where.not(confirmed_at: nil).pluck(:email)
  end

  def report_quota
    MonthlyReportQuota.new(self)
  end
end
