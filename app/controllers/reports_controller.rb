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
    payload.violations.each do |raw_body|
      report = website.reports.create!(raw_headers: raw_headers, raw_body: raw_body)
      ProcessReportJob.perform_later(report.id)
    end

    render json: { message: 'Report accepted' }, status: :accepted
  end

  private

  def raw_headers
    request.headers.env.select { |k, _v| k.start_with?('HTTP_') }
  end
end
