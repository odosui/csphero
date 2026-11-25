# Browsers send Reporting API (`report-to`) reports as cross-origin requests
# and ask for permission first with a CORS preflight.
module AllowsCrossOriginReports
  extend ActiveSupport::Concern

  included do
    before_action :allow_any_origin
  end

  def preflight
    response.headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Max-Age"] = 1.day.to_i.to_s
    head :no_content
  end

  private

  def allow_any_origin
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
