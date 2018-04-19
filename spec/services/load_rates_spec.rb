require 'spec_helper'

describe LoadRates do
  # File has three correct lines
  # File has three invalid lines
  # Line 7 has an invalid amount
  # Line 9 has an invalid date format
  let(:fixture_data) { File.expand_path("#{__dir__}/../fixtures/data1.csv") }

  it "rescue the error and skip the line" do
    expect { LoadRates.new(fixture_data).load }.not_to raise_error
  end

  it "only loads valid lines" do
    expect { LoadRates.new(fixture_data).load }
      .to change { DailyExchangeRate.count }.by(3)
  end
end

