require 'open-uri'
require 'csv'

class LoadRates
  attr_reader :file_path

  def initialize(file_path = ExchangeRateConverter.file_url)
    @file_path = file_path
  end

  def load
    each_line do |num_line, raw_date, raw_value|
      begin
        date = DateHelper.new(raw_date).parse
        value = AmountHelper.to_integer(raw_value)
        DailyExchangeRate.find_or_create_by!(date: date) do |d|
          d.value = value
        end
      rescue ArgumentError => e
        puts "\rInvalid arguments in line #{num_line}. Date: '#{raw_date}', Value: '#{raw_value}'. Skipping..."
        next
      rescue DateHelper::InvalidDateError
        puts "\rInvalid date at line #{num_line}. Date: '#{raw_date}'. Skipping..."
        next
      rescue => e
        puts "\rUnexpected error in line #{num_line}. Skipping..."
        puts e.inspect
        next
      end
    end
  end

  def each_line
    puts "Loading..."
    CSV.new(open(file_path)).each_with_index do |line, index|
      if index > 4
        yield [index, *line]
        show_progression(index)
      end
    end
  end

  def show_progression(num_line)
    $stdout.flush; print "\r#{num_line}"
  end
end
