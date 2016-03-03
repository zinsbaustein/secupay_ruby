require "spec_helper"

describe SecupayRuby::ApiKey::MasterKey do
  include_context "configuration"

  let(:api_key) { "the_master_api_key" }
  let(:master_key) { SecupayRuby::ApiKey::MasterKey.new }

  describe "#key" do
    subject { master_key.key }

    before do
      SecupayRuby.configure do |config|
        config.api_key = api_key
      end
    end

    it { is_expected.to eq(api_key) }
  end
end
