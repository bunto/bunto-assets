# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "asset caching" do
  let(:env) { Bunto::Assets::Env.new(stub_bunto_site) }
  it "sets up a Sprockets FileStore cache for speed" do
    expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to \
      be_kind_of Sprockets::Cache::FileStore
  end
end
