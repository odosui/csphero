class BackfillViolations < ActiveRecord::Migration[8.1]
  def up
    Violation::Backfill.new.run
  end

  def down
    Violation.delete_all
  end
end
