class AddAlertSettingsToWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :websites, :new_violation_alerts, :boolean, null: false, default: true
    add_column :websites, :weekly_digest, :boolean, null: false, default: true
    add_column :websites, :alerted_at, :datetime
  end
end
