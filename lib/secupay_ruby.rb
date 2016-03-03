require "secupay_ruby/version"

module SecupayRuby
  autoload :Configuration, "secupay_ruby/configuration"
  autoload :Payment, "secupay_ruby/payment"

  autoload :Requests, "secupay_ruby/requests/base"
  autoload :ApiKey, "secupay_ruby/api_key/base"
  autoload :DataObjects, "secupay_ruby/data_objects/base"

  autoload :RequestError, "secupay_ruby/exceptions"
  autoload :PaymentStatusError, "secupay_ruby/exceptions"

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= SecupayRuby::Configuration.new
    end

    alias :config :configuration
  end
end
