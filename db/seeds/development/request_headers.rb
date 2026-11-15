module DevSeeds
  # The request headers a browser sends with a report, stored the way the
  # report endpoint stores them (a Ruby hash inspect).
  module RequestHeaders
    MARKER = "HTTP_X_CSPHERO_SEED".freeze

    USER_AGENTS = [
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0",
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0",
      "Mozilla/5.0 (iPhone; CPU iPhone OS 19_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/19.1 Mobile/15E148 Safari/604.1",
      "Mozilla/5.0 (Linux; Android 16; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36",
    ].freeze

    def self.build(host:, random:)
      {
        "HTTP_HOST" => host,
        "HTTP_USER_AGENT" => USER_AGENTS.sample(random: random),
        "HTTP_ACCEPT" => "*/*",
        MARKER => "1",
      }.inspect
    end
  end
end
