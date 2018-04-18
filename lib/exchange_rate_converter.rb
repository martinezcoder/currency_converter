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

  def convert(amount, date)
    unless DailyExchangeRate.any?
      raise DatabaseEmptyError, "DailyExchangeRates is empty. Please, update the data before running again."
    end
    hello
  end

  def hello
    puts "hola"
  end
end
