# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "configuration" do
  let(:env) { Bunto::Assets::Env.new(stub_bunto_site) }
  it "adds the configuration onto env" do
    expect(env.config).not_to be_empty
  end
end
