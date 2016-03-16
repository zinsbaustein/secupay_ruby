require "spec_helper"

describe SecupayRuby::DataObjects::PayoutAccount do
  include_context "configuration"

  let(:payout_account) { SecupayRuby::DataObjects::PayoutAccount.new(attributes) }

  let(:attributes) do
    {
      iban: "value1",
      bic: "value2"
    }
  end

  describe "#initialize" do
    it "stores all user attributes" do
      attributes.keys.each do |attribute|
        expect(payout_account.send(attribute)).to eq(attributes[attribute])
      end
    end
  end

  describe "#to_api_fields" do
    subject { payout_account.to_api_fields }

    it "returns all payout_account attributes in API format" do
      expect(subject).to eq({ iban: "value1",
                              bic: "value2"
                            })
    end
  end




end
