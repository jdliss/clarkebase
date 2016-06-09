require_relative 'support/controller_helpers'
require 'devise'
require 'capybara/rspec'
require 'capybara/webkit/matchers'
# require 'vcr'
# #
# VCR.configure do |config|
#   config.cassette_library_dir = 'spec/cassettes'
#   config.hook_into :webmock
# end

Capybara.javascript_driver = :webkit

RSpec.configure do |config|

  config.include ControllerHelpers, type: :controller
  Warden.test_mode!

  config.after do
    Warden.test_reset!
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
