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
  InvalidDateError = Class.new(StandardError)

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

  # five decimals precision, round to 3 for the result
  DECIMAL_PRECISION=100000

  attr_reader :amount_param, :date_param

  def convert(amount_param, date_param)
    validate_database
    @amount_param = amount_param
    @date_param = date_param

    (Float(amount * exchange_rate) / DECIMAL_PRECISION).round(3)
  end

  private

  def exchange_rate
    DailyExchangeRate.find_conversion(date).value
  end

  def amount
    (Float(amount_param) * DECIMAL_PRECISION).to_i
  end

  def date
    unless date_param.match(/\d{4}-\d{2}-\d{2}/)
      raise InvalidDateError, "Date must have the format 'YYYY-MM-DD'"
    end
    date = Date.parse(date_param).strftime("%Y%m%d").to_i
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
