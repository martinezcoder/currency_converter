require 'spec_helper'

describe LoadRates do

  before do
    allow(ExchangeRateConverter).to receive(:file_url).and_return(fixture_data)
  end

  context "file contains invalid values" do
    let(:fixture_data) { File.expand_path("#{__dir__}/../fixtures/data1.csv") }

    it "rescue the error and skip the line" do
      expect { LoadRates.new.load }.not_to raise_error
    end

    it "only loads valid lines" do
      binding.pry
      expect { LoadRates.new.load }
        .to change { DailyExchangeRate.count }.by(3)
    end

  end

end

