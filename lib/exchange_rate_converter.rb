require 'active_record'
require 'sqlite3'
require 'logger'

# Rails tasks for ActiveRecord
include ActiveRecord::Tasks

# Classes required
lib_dir = File.expand_path("#{__dir__}/../lib/")
Dir["#{lib_dir}/exchange_rate_converter/**/*.rb"].each { |f| require f}

class ExchangeRateConverter
  DatabaseEmptyError = Class.new(StandardError)
  TooOldDateError = Class.new(StandardError)

  class << self
    def env
      ENV["APP_ENV"] ? ENV["APP_ENV"] : "development"
    end

    def config
      Config.instance
    end

    def start
      ActiveRecord::Base.establish_connection(config.db_current)
    end
  end

  attr_reader :date

  def convert(amount, date)
    @date = Date.parse(date).strftime("%Y%m%d").to_i
    run_validations

    "hello"
  end

  private

  def run_validations
    if date < 20000101
      raise TooOldDateError, "Date must be after the year 2000"
    end
    unless database_present?
      raise DatabaseEmptyError, "DailyExchangeRates is empty. Please, update the data before running again."
    end
  end

  def database_present?
    DailyExchangeRate.any?
  end
end
