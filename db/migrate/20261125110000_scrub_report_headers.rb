# Reports used to keep every request header, including proxy headers with the
# visitor's IP address. Only the user agent is ever shown, so keep just that.
class ScrubReportHeaders < ActiveRecord::Migration[8.1]
  LEGACY_FORMAT = '^\{"[A-Z0-9_]+"\s*=>'
  USER_AGENT = '"HTTP_USER_AGENT"\s*=>\s*"([^"]*)"'
  DEV_SEED_MARKER = "%HTTP_X_CSPHERO_SEED%"

  def up
    execute <<~SQL.squish
      UPDATE reports
      SET raw_headers = json_build_object('HTTP_USER_AGENT', substring(raw_headers from #{quote(USER_AGENT)}))::text
      WHERE raw_headers ~ #{quote(LEGACY_FORMAT)} AND raw_headers NOT LIKE #{quote(DEV_SEED_MARKER)}
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
