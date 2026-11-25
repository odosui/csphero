# The request headers kept with a report: only the ones the dashboard shows.
# Everything else a browser or proxy sends, the visitor's IP address included,
# is dropped before the report is stored.
class Report::StoredHeaders
  KEPT = %w[HTTP_USER_AGENT].freeze

  def self.from_request(request)
    new(request.headers.env.slice(*KEPT))
  end

  def self.load(text)
    new(parse(text.to_s))
  end

  # older reports hold a Ruby hash inspect instead of JSON
  def self.parse(text)
    JSON.parse(text)
  rescue JSON::ParserError
    JSON.parse(text.gsub("=>", ":")) rescue {}
  end

  def initialize(headers)
    @headers = headers.to_h.slice(*KEPT)
  end

  def user_agent
    @headers["HTTP_USER_AGENT"]
  end

  def to_json(*)
    @headers.to_json
  end
end
