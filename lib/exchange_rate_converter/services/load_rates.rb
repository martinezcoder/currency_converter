require 'open-uri'
require 'csv'

class LoadRates
  DECIMAL_PRECISION=100000

  def load
    each_line do |num_line, raw_date, raw_value|
      begin
        # TODO: prevent too old date error!!!!!
        date = DateHelper.new(raw_date).parse
        value = AmountHelper.to_integer(raw_value)
        DailyExchangeRate.find_or_create_by!(date: date) do |d|
          d.value = value
        end
      rescue ArgumentError => e
        puts "Invalid arguments in line #{num_line}. Date: '#{raw_date}', Value: '#{raw_value}'"
        next
      rescue => e
        puts "Unexpected error in line #{num_line}"
        puts e.inspect
      end
    end
  end

  def each_line
    seed_data_file = ExchangeRateConverter.file_url

    CSV.new(open(seed_data_file), :headers => :first_row).each_with_index do |line, index|
      if index > 3
        yield [index, *line.to_h.values]
        show_progression
      end
    end
  end

  def show_progression
    $stdout.flush; print "Loading... \\\r"
    $stdout.flush; print "Loading... |\r"
    $stdout.flush; print "Loading... /\r"
    $stdout.flush; print "Loading... -\r"
  end
end
