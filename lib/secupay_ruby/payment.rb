module SecupayRuby
  class Payment
    module Types
      DEBIT = "debit"
      PREPAY = "prepay"
    end

    attr_reader :api_key, :response, :amount, :payment_type, :demo

    INIT_FIELDS = {
      hash: "hash",
      iframe_url: "iframe_url",
      purpose: "purpose",
      payment_data: "payment_data"
    }
    attr_reader(*(INIT_FIELDS.keys))

    STATUS_FIELDS = {
      payment_status:   "payment_status",
      status:           "status",
      created_at:       "created",
      demo:             "demo",
      amount:           "amount",
      payment_details:  "opt",
      transaction_id:   "trans_id"
    }
    attr_reader(*(STATUS_FIELDS.keys))

    def initialize(api_key: SecupayRuby::ApiKey::MasterKey.new, hash: nil)
      @api_key = api_key
      @hash = hash
    end

    def hash?
      !hash.nil?
    end

    def init(amount:, payment_type:, demo: 1)
      @response = nil

      @amount = amount
      @payment_type = payment_type
      @demo = demo

      raise_if_payment_not_initiated
      raise_if_payment_type_invalid

      params = {
        amount: amount,
        demo: demo,
        payment_type: payment_type
      }

      @response = SecupayRuby::Requests::Init.post(api_key: api_key,
                                                   payment: self,
                                                   body: params)

      extract_response_params(INIT_FIELDS)
    end

    def load_status
      raise_if_not_initiated

      @response = nil

      params = { hash: hash }
      @response = SecupayRuby::Requests::Status.post(api_key: api_key,
                                                     payment: self,
                                                     body: params)

      extract_response_params(STATUS_FIELDS)
    end

    def capture
      raise_if_not_initiated

      @response = nil

      @response = SecupayRuby::Requests::Capture.post(api_key: api_key,
                                                      payment: self)
    end

    def cancel
      raise_if_not_initiated

      @response = nil

      @response = SecupayRuby::Requests::Cancel.post(api_key: api_key,
                                                     payment: self)
    end

    class << self
      def get_types(api_key: SecupayRuby::ApiKey::MasterKey.new)
        response = SecupayRuby::Requests::GetTypes.post(api_key: api_key)

        response.data
      end
    end

    private

    def raise_if_not_initiated
      raise PaymentStatusError.new "Not initiated" unless hash?
    end

    def raise_if_payment_type_invalid
      unless valid_payment_type?
        raise PaymentStatusError.new "Payment type not supported"
      end
    end

    def raise_if_payment_not_initiated
      raise PaymentStatusError.new "Payment already initiated" if hash?
    end

    def extract_response_params(fields)
      fields.each do |field_name, param_name|
        instance_variable_set("@#{field_name}", @response.data[param_name])
      end
    end

    def valid_payment_type?
      return false unless @payment_type

      valid_types = Types.constants.map { |constant| Types.const_get constant }
      valid_types.include?(@payment_type)
    end
  end
end
