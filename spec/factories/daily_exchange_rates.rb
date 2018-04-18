FactoryBot.define do
  factory :daily_exchange_rate do
    date  { Faker::Date.between(2.years.ago, Date.today).strftime("%Y%m%d") }
    value { Faker::Number.number(3) }
  end
end
