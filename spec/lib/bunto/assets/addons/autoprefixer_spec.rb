# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe "css auto-prefixing" do
  let(:env) { Bunto::Assets::Env.new(stub_bunto_site) }
  it "prefixes css" do
    result = env.find_asset("prefix.css").to_s
    expect(result).to match %r!-webkit-order:\s+1!
    expect(result).to match %r!-ms-flex-order:\s+1!
  end
end
