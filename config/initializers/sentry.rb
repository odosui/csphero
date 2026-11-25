# Error monitoring is off unless SENTRY_DSN is set. Any Sentry-compatible
# service works: sentry.io, or a self-hosted Sentry or GlitchTip.
if ENV["SENTRY_DSN"].present?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.enabled_environments = %w[production]

    # errors only: no IP addresses, cookies or request bodies, no tracing
    config.send_default_pii = false
    config.traces_sample_rate = 0.0
  end
end
