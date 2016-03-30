# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "asset compression" do
  let(:env) { Bunto::Assets::Env.new(site) }
  let(:site) { stub_bunto_site }

  it "compresses if asked to regardless of environment" do
    stub_asset_config "compress" => { "js" => true, "css" => true }
    expect(env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(env.css_compressor).to eq Sprockets::SassCompressor
    expect(env.compress?("css")).to eq true
    expect(env.compress?( "js")).to eq true
  end

  it "does not default to compression in development" do
    expect(env. js_compressor).to be_nil
    expect(env.css_compressor).to be_nil
    expect(env.compress?("css")).to eq false
    expect(env.compress?( "js")).to eq false
  end

  it "defaults to compression being enabled in production" do
    allow(Bunto).to receive(:env).and_return "production"
    expect(env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(env.css_compressor).to eq Sprockets::SassCompressor
    expect(env.compress?("css")).to eq true
    expect(env.compress?( "js")).to eq true
  end

  it "allows you to disable compression in production" do
    allow(Bunto).to receive(:env).and_return "production"
    stub_asset_config "compress" => {
      "js" => false, "css" => false
    }

    expect(env. js_compressor).to be_nil
    expect(env.css_compressor).to be_nil
    expect(env.compress?("css")).to eq false
    expect(env.compress?( "js")).to eq false
  end
end
