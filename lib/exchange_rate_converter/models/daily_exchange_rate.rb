class DailyExchangeRate < ActiveRecord::Base
  scope :find_conversion, ->(date) { where("date <= ?", date).order(date: :desc).limit(10).first }


  # IMPORTANT NOTE:
  # I am conscient that there are many ways to get the previous value. I decided
  # to go with this one, because the missing dates are always ranges of a couple
  # of days, so using the limit of 10 seems enough.
  #
end
