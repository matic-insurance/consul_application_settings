module Helpers
  module Configuration
    def fixture_path(defaults_fixture)
      File.expand_path("../fixtures/#{defaults_fixture}.yml", __dir__)
    end
  end
end

RSpec.configure do |config|
  config.include(Helpers::Configuration)
end
