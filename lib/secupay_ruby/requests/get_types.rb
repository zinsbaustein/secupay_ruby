module SecupayRuby
  module Requests
    class GetTypes < Base
      def path
        @path ||= %w(payment gettypes).join("/")
      end
    end
  end
end
