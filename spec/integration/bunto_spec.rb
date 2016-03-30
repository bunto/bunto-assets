# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "BUNTO INTEGRATION" do
  describe "Bunto#config[exclude]" do
    subject do
      stub_bunto_site.config[
        "exclude"
      ]
    end

    #

    it "should add the cache to the excludes" do
      expect(subject).to include(
        ".asset-cache"
      )
    end
  end
end
