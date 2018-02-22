require "spec_helper"

describe SecupayRuby::RequestError do
  subject { described_class.new(errors) }

  let(:errors) { 'Request failed' }

  it { expect(subject.message).to eql 'Request failed' }
  it { expect(subject.errors).to be_nil }

  context 'with error object' do
    let(:errors) { [{ 'code' => '3', 'message' => 'Requested service is not available' }] }

    it { expect(subject.message).to eql '[{"code"=>"3", "message"=>"Requested service is not available"}]' }
    it { expect(subject.errors).to eql errors }
  end

  context 'without' do
    let(:errors) { nil }

    it { expect(subject.message).to eql 'SecupayRuby::RequestError' }
    it { expect(subject.errors).to be_nil }
  end
end
