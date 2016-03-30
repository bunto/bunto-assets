# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe Bunto::Assets::Cached do
  let(:cached) { Bunto::Assets::Cached.new(Bunto::Assets::Env.new(site)) }
  let(  :site) { stub_bunto_site }

  it "adds the Bunto instance" do
    expect(cached).to respond_to :bunto
    expect(cached.bunto).to be_kind_of Bunto::Site
  end

  it "adds the parent the *non-cached* instance" do
    expect(cached).to respond_to :parent
    expect(cached.parent).to be_kind_of Bunto::Assets::Env
  end
end
