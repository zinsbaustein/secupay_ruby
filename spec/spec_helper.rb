$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "secupay_ruby"

require "support/shared_context.rb"

require "pry"

require "dotenv"
Dotenv.load

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "vcr/cassettes"
  config.hook_into :webmock
  config.around_http_request do |request|
    VCR.use_cassette('global', record: :new_episodes, &request)
  end
end
