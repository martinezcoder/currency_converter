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
    describe "#validations" do
      before { create_list(:daily_exchange_rate, 3) }

      it "does not raise database emtpty error" do
        d = Date.parse(DailyExchangeRate.last.date.to_s).strftime("%Y-%m-%d")
        expect{ subject.convert(1, d) }
          .not_to raise_error
      end

      context "date has bad format" do
        it "raises an error" do
          expect { subject.convert(1, '20-12-31') }
            .to raise_error(ExchangeRateConverter::InvalidDateError)
        end
      end

      context "date is before year 2000" do
        it "raises an error" do
          expect { subject.convert(1, '1999-12-31') }
            .to raise_error(ExchangeRateConverter::TooOldDateError)
        end
      end
    end

    context "some dates ar missing in DB" do
      before do
        create(:daily_exchange_rate, date: 20001205, value: 1)
        create(:daily_exchange_rate, date: 20001206, value: 2)
        create(:daily_exchange_rate, date: 20001209, value: 1)
        create(:daily_exchange_rate, date: 20001210, value: 1)
      end

      context "given the missing date" do
        let(:missing_date) { '2000-12-08' }

        it "uses the previous date" do
          expect(subject.convert(1, missing_date)).to eq 2
        end
      end

      context "given an existent date" do
        let(:existent_date) { '2000-12-06' }

        it "uses that date" do
          expect(subject.convert(1, existent_date)).to eq 2
        end
      end
    end

    context "amount_param has decimals" do
      before do
        create(:daily_exchange_rate, date: 20000101, value: 1)
      end

      it "returns a float value" do
        expect(subject.convert(1.23, '2000-01-01')).to eq 1.23
      end

      context "amount_params has multiple decimals" do
        it "returns a float value" do
          expect(subject.convert(1.23446, '2000-01-01')).to eq 1.234
          expect(subject.convert(1.23789, '2000-01-01')).to eq 1.238
        end
      end
    end
  end
end
