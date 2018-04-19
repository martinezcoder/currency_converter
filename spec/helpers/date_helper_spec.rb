require 'spec_helper'

describe DateHelper do

  subject(:parse_date) { DateHelper.new(raw_date).parse }

  context "invalid date format" do
    let(:raw_date) { "20-12-2012" }

    it "raises an Invalid Date Error" do
      expect { parse_date }.to raise_error(DateHelper::InvalidDateError)
    end
  end

  context "valid date format" do
    let(:raw_date) { "2012-12-20" }

    it "returns an Integer value with the date" do
      expect(parse_date).to be_a Integer
      expect(parse_date).to eq 20121220
    end
  end
end

