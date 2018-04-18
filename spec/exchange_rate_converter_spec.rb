require 'spec_helper'

describe ExchangeRateConverter do

  subject { described_class.new }

  context "database is empty" do
    it "raises a custom error" do
      expect{ subject.convert(1, '2016-01-09') }
        .to raise_error(ExchangeRateConverter::DatabaseEmptyError)
    end
  end

  context "database is present" do
    before { create_list(:daily_exchange_rate, 3) }

    it "does not raise database emtpty error" do
      expect{ subject.convert(1, '2016-01-09') }
        .not_to raise_error
    end
  end
end
