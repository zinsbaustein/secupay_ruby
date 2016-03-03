require "spec_helper"

describe SecupayRuby::Configuration do
  let(:api_key) { "ABC" }
  let(:production_host) { SecupayRuby::Host::PRODUCTION }
  let(:test_host) { SecupayRuby::Host::TEST }

  it "sets the API key" do
    SecupayRuby.configure do |config|
      config.api_key = api_key
    end

    expect(SecupayRuby.config.api_key).to eq(api_key)
  end

  it "sets host to production by default" do
    expect(SecupayRuby::Configuration.new.host).to eq(production_host)
  end

  it "can set test host" do
    SecupayRuby.configure do |config|
      config.host = test_host
    end

    expect(SecupayRuby.config.host).to eq(test_host)
  end
end
