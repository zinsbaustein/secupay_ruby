module SecupayRuby
  class PaymentStatusError < StandardError; end

  class RequestError < StandardError
    attr_accessor :errors

    def initialize(message_or_errors = nil)
      self.errors = message_or_errors if message_or_errors.is_a?(Array)
      super
    end
  end
end
