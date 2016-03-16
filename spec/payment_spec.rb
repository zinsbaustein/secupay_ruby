require "spec_helper"

describe SecupayRuby::Payment do
  include_context "configuration"

  describe 'initiate payment' do
    subject { payment.init amount: 500,
                     payment_type: SecupayRuby::Payment::Types::PREPAY, user: user }
    let(:user) { nil }

    context 'when using master API key' do
      let(:payment) { SecupayRuby::Payment.new }

      context 'when no user is given' do
        it "can be initiated" do
          subject

          expect_successfull_initialization
        end
      end

      context 'when a user is given' do
        let(:user) { SecupayRuby::DataObjects::User.new(title: "Mr.",
                                                        company: "ACME GmbH & Co KG",
                                                        first_name: "Peter",
                                                        last_name: "Müller",
                                                        street: "Sesamstraße",
                                                        house_number: "Sesamstadt",
                                                        zip: "12345",
                                                        city: "Sesamstadt",
                                                        phone_number: "0190123456",
                                                        date_of_birth: "06.10.1980",
                                                        email: "peter@example.com") }
        it "can be initiated" do
          subject

          expect_successfull_initialization
        end
      end
    end

    context 'when using a subkey' do
      let(:payment) { SecupayRuby::Payment.new api_key: a_sub_key }

      it "can be initiated" do
        subject

        expect_successfull_initialization
      end
    end

    def expect_successfull_initialization
      expect(payment.hash).to eq("lsjqrslfbvoc963425")
      expect(payment.iframe_url).to eq("https://api-dist.secupay-ag.de/payment/lsjqrslfbvoc963425")
      expect(payment.purpose).to eq("TA 6084261")
      expect(payment.payment_data).to include("accountowner" => "secupay AG",
                                              "accountnumber" => "1747013",
                                              "bankcode" => "30050000",
                                              "iban" => "DE88300500000001747013",
                                              "bic" => "WELADEDDXXX",
                                              "bankname" => "Landesbank Hessen-Thüringen Girozentrale NL. Düsseldorf")
    end
  end

  describe 'getting payment status' do
    subject { payment.load_status }

    context 'when using master API key' do
      let(:payment) { SecupayRuby::Payment.new hash: "rovxnjdshwwa962602" }

      it "can get its status" do
        subject

        expect_to_receive_payment_details
      end
    end

    context 'when using a subkey' do
      let(:payment) { SecupayRuby::Payment.new(api_key: a_sub_key,
                                               hash: "rovxnjdshwwa962602") }

      it "can also get its status" do
        subject

        expect_to_receive_payment_details
      end
    end

    def expect_to_receive_payment_details
      expect(payment.hash).to eq 'rovxnjdshwwa962602'
      expect(payment.payment_status).to be nil
      expect(payment.status).to eq 'scored'
      expect(payment.demo).to eq 1
      expect(payment.created_at).to eq '2016-02-24 13:59:02'
      expect(payment.amount).to eq 500
      expect(payment.payment_details).to be nil
      expect(payment.transaction_id).to eq '6083438'
    end
  end

  it "can capture a payment" do
    payment = SecupayRuby::Payment.new(hash: "rovxnjdshwwa962602")
    payment.load_status

    expect{ payment.cancel }.to raise_error(SecupayRuby::RequestError ,'[{"code"=>"0004", "message"=>"nicht abgeschlossene Zahlung kann nicht storniert werden"}]')
  end

  it "can get a list of supported payment types" do
    expect(SecupayRuby::Payment.get_types).to eq(%w(debit prepay))
  end
end
