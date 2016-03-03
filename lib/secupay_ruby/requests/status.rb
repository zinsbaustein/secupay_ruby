module SecupayRuby
  module Requests
    class Status < Base
      def path
        @path ||= %w(payment status).join("/")
      end
    end
  end
end
