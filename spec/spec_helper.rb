# frozen_string_literal: true

ENV['ENVIRONMENT'] = 'test'

require 'capybara/rspec'
require 'simplecov'
require 'simplecov-console'
require 'pg'
require_relative './setup_test_database'
require_relative '../lib/database_connection'
require_relative '../lib/user'
require_relative '../lib/booking'
require_relative '../lib/spaces'
require_relative '../controllers/app'
require 'date'
require_relative './features/web_helpers'

Capybara.app = MakersBnB

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::Console
                                                                 # Want a nice code coverage website? Uncomment this next line!
                                                                 # SimpleCov::Formatter::HTMLFormatter
                                                               ])

SimpleCov.start

RSpec.configure do |config|
  config.before(:each) do
    setup_test_database
  end
end
