class ReportsController < ApplicationController
  include AllowsCrossOriginReports

  skip_before_action :verify_authenticity_token

  def create
    website = Website.find_by(token: params[:token])
    if website.nil?
      render json: { error: 'Invalid token' }, status: :unprocessable_entity
      return
    end

    return head :too_many_requests if website.company.report_quota.exhausted?

    payload = ReportPayload.new(request.body.read(ReportPayload::MAX_BYTES + 1))
    return head :bad_request unless payload.valid?

    # store raw data, and defer the processing
    headers = Report::StoredHeaders.from_request(request).to_json
    payload.violations.each do |raw_body|
      report = website.reports.create!(raw_headers: headers, raw_body: raw_body)
      ProcessReportJob.perform_later(report.id)
    end

    render json: { message: 'Report accepted' }, status: :accepted
  end
end
