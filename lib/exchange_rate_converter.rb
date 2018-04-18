require 'active_record'
require 'sqlite3'
require 'logger'

# Rails tasks for ActiveRecord
include ActiveRecord::Tasks

# Classes required
lib_dir = File.expand_path("#{__dir__}/../lib/")
Dir["#{lib_dir}/exchange_rate_converter/**/*.rb"].each { |f| require f}

module ExchangeRateConverter
  DatabaseEmptyError = Class.new(StandardError)

  def self.env
    ENV["APP_ENV"] ? ENV["APP_ENV"] : "development"
  end

  def self.config
    Config.instance
  end

  def self.start
    ActiveRecord::Base.establish_connection(config.db_current)
  end

  def convert(amount, date)
    raise DatabaseEmptyError, database_emtpy_msg if DailyExchangesRate.empty?
  end
end
