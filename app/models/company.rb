class Company < ApplicationRecord
  validates :name, presence: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :websites, dependent: :destroy
  has_many :reports, through: :websites

  def report_quota
    MonthlyReportQuota.new(self)
  end
end
