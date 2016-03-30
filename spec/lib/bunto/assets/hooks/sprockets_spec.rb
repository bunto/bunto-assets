# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "sprockets on Bunto" do
  let(:env) { Bunto::Assets::Env.new(stub_bunto_site) }
  it "makes sure that sprockets is on the Bunto instance" do
    expect(env.bunto.sprockets).to be_kind_of Bunto::Assets::Env
  end
end
