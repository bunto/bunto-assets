# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe "transpiling-es6" do
  let(:env) { Bunto::Assets::Env.new(stub_bunto_site) }
  it "transpiles es6" do
    expect(env.find_asset("transpile.js").to_s.strip.gsub(/$\n+/, " ")).to eq \
      %Q{"use strict"; var Hello = Symbol();}
  end
end
