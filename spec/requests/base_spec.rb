require "spec_helper"

describe SecupayRuby::Requests::Base do
  include_context "configuration"

  subject(:request) { request_class.post api_key: SecupayRuby::ApiKey::MasterKey.new }

  let(:request_class) do
    Class.new(described_class) do
      def path
        @path ||= ["foo", "bar"].join("/")
      end
    end
  end

  context 'when request fails' do
    it 'sets error message' do
      expect { request }.to raise_error(SecupayRuby::RequestError) { |error|
        expect(error.message).to eql '[{"code"=>"3", "message"=>"Requested service is not available"}]'
      }
    end

    it 'includes errors as object' do
      expect { request }.to raise_error(SecupayRuby::RequestError) { |error|
        expect(error.errors).to eql [{'code' => '3', 'message' => 'Requested service is not available' }]
      }
    end
  end
end
