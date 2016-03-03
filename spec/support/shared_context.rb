RSpec.shared_context "configuration" do
  let(:config) do
    {
      api_key: ENV["TEST_API_KEY"],
      host: SecupayRuby::Host::TEST,
      url_success: "http://localhost.com/success",
      url_failure: "http://localhost.com/failure",
      url_push: "http://localhost.com/push"
    }
  end

  let(:master_key) { SecupayRuby::ApiKey::MasterKey.new }
  let(:a_sub_key) { SecupayRuby::ApiKey::SubKey.new(ciphertext: "zPYy751cN4GV1NG2CKmyxbXsnSNRDy9G2Dg1CnbIXVYnnXpNM51PiQ==\n",
                                            iv: "9C7xudH3ZzBGUE5J\n",
                                            mac: "CsfACD7fd5pL4AaA3ZcKeg==\n",
                                            project_name: 'name of the project',
                                            contract_id: '156822') }

  before do
    SecupayRuby.configure do |configuration|
      configuration.api_key = config[:api_key]
      configuration.host = config[:host]
      configuration.url_success = config[:url_success]
      configuration.url_failure = config[:url_failure]
      configuration.url_push = config[:url_push]
    end
  end
end
