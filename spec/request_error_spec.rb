require "spec_helper"

describe SecupayRuby::RequestError do
  subject(:request_error) { described_class.new(errors) }

  let(:errors) { 'Request failed' }

  it { expect(request_error.message).to eql 'Request failed' }
  it { expect(request_error.errors).to be_nil }

  context 'with error object' do
    let(:errors) { [{ 'code' => '3', 'message' => 'Requested service is not available' }] }

    it { expect(request_error.message).to eql '[{"code"=>"3", "message"=>"Requested service is not available"}]' }
    it { expect(request_error.errors).to eql errors }
  end

  context 'without' do
    let(:errors) { nil }

    it { expect(request_error.message).to eql 'SecupayRuby::RequestError' }
    it { expect(request_error.errors).to be_nil }
  end
end
