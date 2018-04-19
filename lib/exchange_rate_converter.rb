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

  ## Config
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

    def file_url
      config.db_current["seeds_path"]
    end
  end

  attr_reader :amount_param, :date_param

  def convert(amount_param, date_param)
    validate_database
    @amount_param = amount_param
    @date_param = date_param

    AmountHelper.to_float(amount * exchange_rate)
  end

  private

  def exchange_rate
    AmountHelper.to_float(
      DailyExchangeRate.find_conversion(date).value
    )
  end

  def amount
    AmountHelper.to_integer(amount_param)
  end

  def date
    date = DateHelper.new(date_param).parse
    if date < 20000101
      raise TooOldDateError, "Date must be after the year 2000"
    end
    date
  end

  def validate_database
    unless DailyExchangeRate.any?
      raise DatabaseEmptyError, "DailyExchangeRates is empty. Please, update the data before running again."
    end
  end
end

# Start the database
ExchangeRateConverter.start
