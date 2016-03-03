module SecupayRuby
  module ApiKey
    class MasterKey
      def key
        SecupayRuby.config.api_key
      end
    end
  end
end
