module SecupayRuby
  module Requests
    class RequestApiKey < Base
      def path
        @path ||= ["payment", "requestapikey"].join("/")
      end
    end
  end
end
