# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe Bunto::Assets::Env do
  let( :env) { Bunto::Assets::Env.new(site) }
  before(:each, :process => true) { site.process }
  let(:path) { site.in_dest_dir("/assets") }
  let(:site) { stub_bunto_site }

  before :all do
    @site = stub_bunto_site
    @env  = Bunto::Assets::Env.new(@site)
  end

  describe "#excludes" do
    subject { @env.excludes }
    it { is_expected.to include ".asset-cache" }
  end

  it "adds the current Bunto instance" do
    expect(@env.bunto).to eq @site
  end

  it "creates a new used set for assets that have been used" do
    expect(@env.used).to be_kind_of Set
    expect(@env.used).to be_empty
  end

  it "returns a path with the CDN and prefix in production" do
    allow(Bunto).to receive(:env).and_return "production"
    stub_asset_config "cdn" => "//localhost"
    expect(@env.prefix_path).to eq "//localhost/assets"
  end

  it "skips the prefix in production if skip_prefix_with_cdn => true" do
    stub_asset_config "skip_prefix_with_cdn" => true, "cdn" => "//localhost"
    expect(@env.prefix_path).to eq "/assets"
  end

  it "does not use a cdn in development mode" do
    expect(@env.prefix_path).to eq "/assets"
  end

  it "uses Buntos baseurl when prefixing the url" do
    @env.bunto.config["baseurl"] = "/hello"
    expect(@env.prefix_path).to eq "/hello/assets"
    @env.bunto.config["baseurl"] = ""
  end

  it "skips the baseurl on a cdn if asked to" do
    allow(Bunto).to receive(:env).and_return "production"
    stub_asset_config site, "skip_baseurl_with_cdn" => true, "cdn" => "//localhost"
    env.bunto.config["baseurl"] = "/hello"
    expect(env.prefix_path).to eq \
      "//localhost/assets"
  end

  it "allows the user to set a relative path" do
    stub_asset_config site, "prefix" => "assets"
    expect(env.prefix_path).to eq "assets"
  end

  it "digests by default in production" do
    allow(Bunto).to receive(:env).and_return "production"
    expect(env.digest?).to be true
    expect(env.send(:as_path, env.find_asset("bundle.css"))). \
      to match %r!bundle-([a-zA-Z0-9]+)\.css\Z!
  end

  it "allows a user to disable digesting in production" do
    allow(Bunto).to receive(:env).and_return "production"
    stub_asset_config "digest" => false
    expect(@env.digest?).to be false
    expect(@env.send(:as_path, @env.find_asset("bundle.css"))).to eq \
      @site.in_dest_dir(@env.asset_config["prefix"], "bundle.css")
  end

  it "does not enable digesting by default in development" do
    expect(@env.digest?).to be false
    expect(@env.send(:as_path, @env.find_asset("bundle.css"))).to eq \
      @site.in_dest_dir(@env.asset_config["prefix"], "bundle.css")
  end

  it "allows you to enable digesting in development" do
    stub_asset_config "digest" => true
    expect(@env.digest?).to be true
    expect(@env.send(:as_path, @env.find_asset("bundle.css"))).to match \
      %r!bundle-([a-zA-Z0-9]+)\.css\Z!
  end

  it "overrides the default object cache" do
    expect(@env.cached).to be_kind_of \
      Bunto::Assets::Cached
  end

  it "writes the assets the user requests it to write", :process => true do
    expect(Dir[File.join(path, "*")]).not_to be_empty
  end

  it "writes cached assets on a simple refresh", :process => true do
    path_ = Pathname.new(path)
    path_.rmtree

    site.sprockets.used.clear
    site.sprockets.write_all
    expect(path_).to(exist)
    expect(path_.children). \
      not_to(be_empty)
  end

  it "writes missing assets even when cached", :process => true do
    file = Dir[File.join(path, "*")][0]
    FileUtils.rm(file)

    site.sprockets.write_all
    expect(Pathname.new(file)).to exist
  end
end
