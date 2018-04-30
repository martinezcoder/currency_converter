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

      context "date is before year 2000" do
        it "raises an error" do
          expect { subject.convert(1, '1999-12-31') }
            .to raise_error(ExchangeRateConverter::TooOldDateError)
        end
      end
    end

    context "some dates ar missing in DB" do
      before do
        create(:daily_exchange_rate, date: 20001205, value: 100000)
        create(:daily_exchange_rate, date: 20001206, value: 50000)
        create(:daily_exchange_rate, date: 20001209, value: 100000)
        create(:daily_exchange_rate, date: 20001210, value: 100000)
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
        create(:daily_exchange_rate, date: 20000101, value: 100000)
      end

      it "returns a float value" do
        expect(subject.convert(1.23, '2000-01-01')).to eq 1.23
      end

      context "amount_params has multiple decimals" do
        it "returns a float value" do
          expect(subject.convert(1.23446, '2000-01-01')).to eq 1.2345
          expect(subject.convert(1.23789, '2000-01-01')).to eq 1.2379
        end
      end
    end

    context "the value of conversion has decimals" do
      before do
        create(:daily_exchange_rate, date: 20000101, value: 123789)
      end

      it "returns the float value rounded to 4 decimals" do
        expect(subject.convert(1, '2000-01-01')).to eq 0.8078
      end
    end
  end
end
