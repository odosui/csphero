module DevSeeds
  # Realistic violations, each with a relative weight of how often it shows up.
  module ViolationCatalog
    Violation = Struct.new(:directive, :blocked_uri, :source_file, :sample, :weight, keyword_init: true)

    VIOLATIONS = [
      Violation.new(directive: "script-src-elem", blocked_uri: "https://www.googletagmanager.com/gtag/js?id=G-8XK2LQ4M1Z", weight: 14),
      Violation.new(directive: "script-src-elem", blocked_uri: "https://static.hotjar.com/c/hotjar-3412987.js?sv=6", weight: 8),
      Violation.new(directive: "script-src-elem", blocked_uri: "https://js.intercomcdn.com/frame-modern.4f1c2a.js", weight: 5),
      Violation.new(directive: "script-src", blocked_uri: "inline", sample: "window.dataLayer = window.dataLayer || [];", weight: 9),
      Violation.new(directive: "script-src", blocked_uri: "eval", sample: "new Function(\"return this\")", weight: 3),
      Violation.new(directive: "style-src-elem", blocked_uri: "https://fonts.googleapis.com/css2?family=Roboto:wght@400;700", weight: 7),
      Violation.new(directive: "style-src-attr", blocked_uri: "inline", sample: "display:none", weight: 4),
      Violation.new(directive: "font-src", blocked_uri: "https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxK.woff2", weight: 7),
      Violation.new(directive: "font-src", blocked_uri: "https://cdn.jsdelivr.net/gh/lykmapipo/themify-icons@0.1.2/fonts/themify.ttf", weight: 3),
      Violation.new(directive: "img-src", blocked_uri: "https://www.facebook.com/tr?id=1029384756&ev=PageView", weight: 6),
      Violation.new(directive: "img-src", blocked_uri: "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg", weight: 2),
      Violation.new(directive: "connect-src", blocked_uri: "https://api.segment.io/v1/t", weight: 6),
      Violation.new(directive: "connect-src", blocked_uri: "https://o450123.ingest.sentry.io/api/5512/envelope/", weight: 4),
      Violation.new(directive: "frame-src", blocked_uri: "https://www.youtube.com/embed/dQw4w9WgXcQ", weight: 2),
      Violation.new(directive: "font-src", blocked_uri: "chrome-extension", source_file: "chrome-extension", weight: 5),
      Violation.new(directive: "script-src-elem", blocked_uri: "chrome-extension", source_file: "chrome-extension", weight: 4),
      Violation.new(directive: "style-src-elem", blocked_uri: "moz-extension", source_file: "moz-extension", weight: 2),
    ].freeze

    def self.sample(random)
      pick = random.rand(VIOLATIONS.sum(&:weight))
      VIOLATIONS.each do |violation|
        return violation if pick < violation.weight
        pick -= violation.weight
      end
    end
  end
end
