module DevSeeds
  # When reports arrive: denser recently, thinning out across 90 days, so
  # every time range filter has something to show.
  module ReportTimes
    BANDS = [
      [0.30, 0.hours, 24.hours],
      [0.30, 1.day, 7.days],
      [0.25, 7.days, 30.days],
      [0.15, 30.days, 89.days],
    ].freeze

    def self.spread(count, random:, now: Time.current)
      BANDS.flat_map do |share, from, to|
        Array.new((count * share).round) { now - random.rand(from.to_f..to.to_f) }
      end
    end

    # a burst within one hour, like a deploy that broke the policy
    def self.burst(count, hours_ago:, random:, now: Time.current)
      start = now - hours_ago.hours
      Array.new(count) { start + random.rand(0.0..1.hour.to_f) }
    end
  end
end
