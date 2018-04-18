$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

ENV['APP_ENV'] ||= 'test'

require 'exchange_rate_converter'
require 'factory_bot'
require 'database_cleaner'
require 'faker'
require 'pry'

ActiveRecord::Migration.maintain_test_schema!

ExchangeRateConverter.start

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
FactoryBot.find_definitions
