class DateHelper
  InvalidDateError = Class.new(StandardError)

  attr_reader :raw_date, :date

  def initialize(raw_date)
    @raw_date = raw_date
  end

  def parse
    unless raw_date.match(/\d{4}-\d{2}-\d{2}/)
      raise InvalidDateError, "Date must have the format 'YYYY-MM-DD'"
    end
    @date = Date.parse(raw_date).strftime("%Y%m%d").to_i
  end
end
