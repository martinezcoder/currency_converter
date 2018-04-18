class DailyExchangeRate < ActiveRecord::Base
  scope :find_conversion, ->(date) { where("date <= ?", date).order(date: :desc).limit(10).first }
end
