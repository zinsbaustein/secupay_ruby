require "spec_helper"

describe SecupayRuby::ApiKey::SubKey do
  include_context "configuration"

  let(:project_name) { "name of the project" }

  describe "generation of new API key" do
    subject { SecupayRuby::ApiKey::SubKey.request_api_key(project_name: project_name,
                                                          user: user,
                                                          payout_account: payout_account) }

    let(:user) do
      SecupayRuby::DataObjects::User.new( title: "Mr.",
                                          company: "ACME GmbH & Co KG",
                                          first_name: "Peter",
                                          last_name: "Müller",
                                          street: "Sesamstraße",
                                          house_number: "Sesamstadt",
                                          zip: "12345",
                                          city: "Sesamstadt",
                                          phone_number: "0190123456",
                                          date_of_birth: "06.10.1980",
                                          email: "peter@example.com")
    end

    let(:payout_account) do
      SecupayRuby::DataObjects::PayoutAccount.new(iban: "DE123",
                                                  bic: "BIC456")
    end

    it 'generates an API key' do
      expect(subject.key).to eq 'd29dbf0de35f6b1e8a7665e60196d5b7ccd3ba50'
    end

    it 'returns the key in encrypted form' do
      expect(subject).to be_a_kind_of(SecupayRuby::ApiKey::SubKey)

      expect(subject.ciphertext).to match(base64_regex)
      expect(subject.iv).to match(base64_regex)
      expect(subject.mac).to match(base64_regex)
      expect(subject.project_name).to eq(project_name)
      expect(subject.contract_id).to eq('156826')
    end

    def base64_regex
      /^(?:[A-Za-z0-9+\/]{4}\n?)*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/
    end
  end

  describe 'creation of API key object from stored data' do
    subject { SecupayRuby::ApiKey::SubKey.new(ciphertext: ciphertext,
                                              iv: iv,
                                              mac: mac,
                                              project_name: project_name,
                                              contract_id: contract_id) }

    let(:ciphertext) { "zPYy751cN4GV1NG2CKmyxbXsnSNRDy9G2Dg1CnbIXVYnnXpNM51PiQ==\n" }
    let(:iv) { "9C7xudH3ZzBGUE5J\n" }
    let(:mac) { "CsfACD7fd5pL4AaA3ZcKeg==\n" }
    let(:project_name) { 'name of the project' }
    let(:contract_id) { '156822' }

    it 'allows to recreate the key object from the encrypted data' do
      expect(subject.key).to eq('78b4ddb9860176fd3c6227b44df9cdd8d9581ae4')
    end

    context 'when ciphtertext is changed' do
      let(:ciphertext) { "some_other_value==\n" }

      it 'raises an error' do
        expect{ subject.key }.to raise_error(OpenSSL::Cipher::CipherError)
      end
    end

    context 'when iv is changed' do
      let(:iv) { "some_iv==\n" }

      it 'raises an error' do
        expect{ subject.key }.to raise_error(OpenSSL::Cipher::CipherError)
      end
    end

    context 'when mac is changed' do
      let(:iv) { "some_mac==\n" }

      it 'raises an error' do
        expect{ subject.key }.to raise_error(OpenSSL::Cipher::CipherError)
      end
    end

    context 'when project name is changed' do
      let(:project_name) { "a different project" }

      it 'raises an error' do
        expect{ subject.key }.to raise_error(OpenSSL::Cipher::CipherError)
      end
    end

    context 'when contract id is changed' do
      let(:contract_id) { 'does not matter - not authenticated' }

      it 'does not authenticate contract id' do
        expect(subject.key).to eq('78b4ddb9860176fd3c6227b44df9cdd8d9581ae4')
      end
    end
  end
end
