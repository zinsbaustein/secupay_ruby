require "spec_helper"

describe SecupayRuby do
  include_context "configuration"

  it "has a version number" do
    expect(SecupayRuby::VERSION).not_to be nil
  end
end
