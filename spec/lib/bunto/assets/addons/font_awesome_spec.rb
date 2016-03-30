# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe "font-awesome" do
  let(:env) { Bunto::Assets::Env.new(stub_bunto_site) }
  it "makes font-awesome available" do
    expect(env.find_asset("font-awesome").to_s).to match %r!fa-.+:before\s+{!
  end
end
