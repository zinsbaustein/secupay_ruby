module SecupayRuby
  module Requests
    class Cancel < Base
      def path
        @path ||= ["payment", payment.hash, "cancel"].join("/")
      end
    end
  end
end
