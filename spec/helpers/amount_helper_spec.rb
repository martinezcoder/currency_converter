require 'spec_helper'

describe AmountHelper do
  describe "#to_integer" do

    subject(:result) { AmountHelper.to_integer(amount) }

    context "given an amount without decimals" do
      let(:amount) { 120 }

      it { expect(result).to be_a Integer }
      it { expect(result).to eq 12000000 }
    end

    context "given an amount with decimals" do
      let(:amount) { 120.3456 }

      it { expect(result).to be_a Integer }
      it { expect(result).to eq 12034560 }
    end

    context "given an string amount" do
      context "with decimals" do
        let(:amount) { "120" }

        it { expect(result).to be_a Integer }
        it { expect(result).to eq 12000000 }
      end
      context "without decimals" do
        let(:amount) { "120.3456" }

        it { expect(result).to be_a Integer }
        it { expect(result).to eq 12034560 }
      end
    end
  end

  describe "#to_float" do
    subject(:result) { AmountHelper.to_float(amount) }

    context "given a value with all the decimals" do
      let(:amount) { 12345678 }

      it { expect(result).to be_a Float }

      it "rounds three decimals" do
        expect(result).to eq 123.457
      end
    end
  end
end
