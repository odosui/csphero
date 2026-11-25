ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

require_relative "support/env_helper"
ActiveSupport::TestCase.include EnvHelper
require_relative "support/alert_test_data"
ActiveSupport::TestCase.include AlertTestData
