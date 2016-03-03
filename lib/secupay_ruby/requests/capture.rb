module SecupayRuby
  module Requests
    class Capture < Base
      def path
        @path ||= ["payment", payment.hash, "capture"].join("/")
      end
    end
  end
end
