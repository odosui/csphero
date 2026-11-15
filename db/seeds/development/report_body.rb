module DevSeeds
  # A report body in one of the two wire formats the endpoint accepts:
  # legacy `report-uri` (hyphenated) or the Reporting API (camelCase).
  module ReportBody
    def self.build(violation:, document_uri:, policy:, disposition:, random:)
      if random.rand < 0.5
        legacy(violation, document_uri, policy, disposition)
      else
        reporting_api(violation, document_uri, policy, disposition)
      end.to_json
    end

    def self.legacy(violation, document_uri, policy, disposition)
      {
        "csp-report" => {
          "document-uri" => document_uri,
          "referrer" => "",
          "violated-directive" => violation.directive,
          "effective-directive" => violation.directive,
          "original-policy" => policy,
          "disposition" => disposition,
          "blocked-uri" => violation.blocked_uri,
          "source-file" => violation.source_file,
          "status-code" => 200,
          "script-sample" => violation.sample.to_s,
        }.compact,
      }
    end

    def self.reporting_api(violation, document_uri, policy, disposition)
      [{
        "type" => "csp-violation",
        "url" => document_uri,
        "body" => {
          "documentURL" => document_uri,
          "effectiveDirective" => violation.directive,
          "originalPolicy" => policy,
          "disposition" => disposition,
          "blockedURL" => violation.blocked_uri,
          "sourceFile" => violation.source_file,
          "statusCode" => 200,
          "sample" => violation.sample.to_s,
        }.compact,
      }]
    end
  end
end
