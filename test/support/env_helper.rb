module EnvHelper
  def with_env(overrides)
    previous = overrides.keys.to_h { |name| [name, ENV[name]] }
    overrides.each { |name, value| ENV[name] = value }
    yield
  ensure
    previous.each { |name, value| ENV[name] = value }
  end
end
