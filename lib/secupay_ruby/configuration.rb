module SecupayRuby
  module Host
    TEST = "https://api-dist.secupay-ag.de"
    PRODUCTION = "https://api.secupay.ag"
  end

  class Configuration
    attr_accessor :api_key,
                  :host,
                  :url_success,
                  :url_failure,
                  :url_push

    def initialize
      self.host = SecupayRuby::Host::PRODUCTION
    end
  end
end
