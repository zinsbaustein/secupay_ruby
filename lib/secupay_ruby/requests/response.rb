module SecupayRuby
  module Requests
    class Response
      attr_accessor :http_status, :status, :data, :errors

      def initialize(http_status:, status:, data:, errors:)
        self.http_status = http_status
        self.status = status
        self.data = data
        self.errors = errors
      end

      def failed?
        http_status != "200" || status != "ok"
      end
    end
  end
end

