# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe "logger hook" do
  let(:env) {  Bunto::Assets::Env.new(stub_bunto_site) }
  it "sets the sprockets logger to use Bunto's logger" do
    expect(env.logger).to be_kind_of \
      Bunto::Assets::Logger
  end
end
