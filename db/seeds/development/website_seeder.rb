module DevSeeds
  # Fills one website with reports. Re-running replaces the reports it made
  # before and leaves real ones alone.
  class WebsiteSeeder
    PAGES = ["/", "/pricing", "/login", "/dashboard", "/settings/billing", "/blog/csp-in-2026"].freeze

    def initialize(website, count:, report_only_share:, burst: nil, random: Random.new(42))
      @website = website
      @count = count
      @report_only_share = report_only_share
      @burst = burst
      @random = random
    end

    def call
      remove_previous_seeds
      timestamps.each { |at| create_report(at) }
    end

    private

    attr_reader :website, :random

    def remove_previous_seeds
      website.reports.where("raw_headers LIKE ?", "%#{RequestHeaders::MARKER}%").delete_all
    end

    def timestamps
      times = ReportTimes.spread(@count, random: random)
      times += ReportTimes.burst(@burst[:count], hours_ago: @burst[:hours_ago], random: random) if @burst
      times
    end

    def create_report(at)
      body = ReportBody.build(
        violation: ViolationCatalog.sample(random),
        document_uri: "https://#{website.domain}#{PAGES.sample(random: random)}",
        policy: policy,
        disposition: random.rand < @report_only_share ? "report" : "enforce",
        random: random,
      )

      report = website.reports.build(
        raw_body: body,
        raw_headers: RequestHeaders.build(host: website.domain, random: random),
        created_at: at,
        updated_at: at,
      )
      report.parse!
    end

    def policy
      "default-src 'self'; script-src 'self'; style-src 'self'; font-src 'self'; " \
        "img-src 'self' data:; connect-src 'self'; frame-src 'none'; " \
        "report-uri https://csphero.com/report/#{website.token}"
    end
  end
end
