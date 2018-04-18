require 'spec_helper'

describe DailyExchangeRate, type: :model do
  describe "#find_conversion" do
    let!(:day1) { create(:daily_exchange_rate, date: '20001205') }
    let!(:day2) { create(:daily_exchange_rate, date: '20001206') }
    let!(:day5) { create(:daily_exchange_rate, date: '20001209') }
    let!(:day6) { create(:daily_exchange_rate, date: '20001210') }

    let(:missing_day4) { '20001208' }

    it "finds the previous date" do
      expect(described_class.find_conversion(missing_day4)).to eq(day2)
    end
  end
end
