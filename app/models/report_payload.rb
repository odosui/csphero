# The body of one request to the reporting endpoint, split into the violations
# it carries: one for the legacy `report-uri` format, any number for the
# Reporting API, which batches reports into an array.
class ReportPayload
  MAX_BYTES = 64.kilobytes
  CSP_VIOLATION = "csp-violation"

  def initialize(body)
    @body = body.to_s
  end

  def valid?
    violations.any?
  end

  # each violation as the JSON to store with its report
  def violations
    @violations ||= case parsed
      when Hash then [@body]
      when Array then parsed.select { csp_violation?(_1) }.map(&:to_json)
      else []
    end
  end

  private

  def parsed
    return if @body.bytesize > MAX_BYTES

    JSON.parse(@body)
  rescue JSON::ParserError
    nil
  end

  def csp_violation?(entry)
    entry.is_a?(Hash) && entry.fetch("type", CSP_VIOLATION) == CSP_VIOLATION
  end
end
