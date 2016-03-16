module SecupayRuby
  module DataObjects
    autoload :User, "secupay_ruby/data_objects/user"
    autoload :PayoutAccount, "secupay_ruby/data_objects/payout_account"

    class Base

      def to_api_fields
        api_fields.keys.inject({}) do |hash, key|
          hash[api_fields[key]] = self.send(key)
          hash
        end
      end

      def initialize(attributes);
        class << self
          self
        end.class_eval do
          attr_accessor(*(self::API_FIELDS.keys))
        end

        api_fields.keys.each do |key|
          value = attributes[key]

          self.send("#{key}=", value)
        end
      end

      private

      def api_fields
        self.class::API_FIELDS
      end
    end
  end
end
