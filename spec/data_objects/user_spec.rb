require "spec_helper"

describe SecupayRuby::DataObjects::User do
  include_context "configuration"

  let(:user) { SecupayRuby::DataObjects::User.new(attributes) }

  let(:attributes) do
    {
      title: "value1",
      company: "value2",
      first_name: "value3",
      last_name: "value4",
      street: "value5",
      house_number: "value6",
      zip: "value7",
      city: "value8",
      phone_number: "value9",
      date_of_birth: "value10",
      email: "value11"
    }
  end

  describe "#initialize" do
    it "stores all user attributes" do
      attributes.keys.each do |attribute|
        expect(user.send(attribute)).to eq(attributes[attribute])
      end
    end

    it 'throws an error if any argument is missing' do
      attributes.keys.each do |attribute|
        partial_attributes = attributes
        partial_attributes[attribute] = nil;

        expect{ SecupayRuby::DataObjects::User.new(partial_attributes) }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "#to_api_fields" do
    subject { user.to_api_fields }

    it "returns all user attributes in API format" do
      expect(subject).to eq({ title: "value1",
                              company: "value2",
                              firstname: "value3",
                              lastname: "value4",
                              street: "value5",
                              housenumber: "value6",
                              zip: "value7",
                              city: "value8",
                              telephone: "value9",
                              dob_value: "value10",
                              email: "value11"
                            })
    end
  end




end
