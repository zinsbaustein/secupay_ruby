module SecupayRuby
  module ApiKey
    autoload :MasterKey, "secupay_ruby/api_key/master_key"
    autoload :SubKey, "secupay_ruby/api_key/sub_key"

    class Base
      def key
        raise NotImplementedError.new 'Abstract method'
      end
    end
  end
end