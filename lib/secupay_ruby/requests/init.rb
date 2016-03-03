module SecupayRuby
  module Requests
    class Init < Base
      def defaults
        super.merge(
          url_success: SecupayRuby.config.url_success,
          url_failure: SecupayRuby.config.url_failure,
          url_push: SecupayRuby.config.url_push)
      end

      def path
        @path ||= %w(payment init).join("/")
      end
    end
  end
end
