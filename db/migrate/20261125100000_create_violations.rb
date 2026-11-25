class CreateViolations < ActiveRecord::Migration[8.1]
  def change
    create_table :violations do |t|
      t.references :website, null: false, foreign_key: true, index: false
      t.string :directive, null: false
      t.string :blocked_source, null: false
      t.integer :reports_count, null: false, default: 0
      t.datetime :first_seen_at, null: false
      t.datetime :last_seen_at, null: false
      t.datetime :notified_at

      t.index [:website_id, :directive, :blocked_source], unique: true, name: "index_violations_on_signature"
      t.index [:website_id, :first_seen_at]
    end
  end
end
