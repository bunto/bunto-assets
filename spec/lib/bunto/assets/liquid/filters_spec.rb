# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe Bunto::Assets::Liquid::Filters do
  before(:each) { site.process }; let(:site) { stub_bunto_site }
  it "uses tags and returns the HTML" do
    expect(fragment(site.pages.first.to_s).xpath( \
      "p//img[contains(@alt, 'filter')]").size).to eq 1
  end
end
