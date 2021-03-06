# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Magick Image Proxy" do
  before :all do
    @site  = stub_bunto_site
    @env   = Bunto::Assets::Env.new(@site)
    @asset = @env.find_asset("ubuntu.png")
  end

  def stub_tag(*args)
    Bunto::Assets::Liquid::Tag.send(:new, "img", "ubuntu.png #{args.join(" ")}", []). \
      render(OpenStruct.new(:registers => { :site => @site }))
  end

  def get_asset(html)
    Pathname.new(@env.in_cache_dir(fragment(html).children.first.attr("src").gsub(/^#{ \
      Regexp.escape(@env.asset_config["prefix"])}\//, "")))
  end

  def as_magick(path)
    MiniMagick::Image.open(path.to_s)
  end

  it "allows a user to adjust quality" do
    asset = get_asset(stub_tag("magick:quality:99"))
    expect(Pathname.new(@asset.filename).size).to be > \
      asset.size
  end

  it "allows the user to resize" do
    expect(as_magick(get_asset(stub_tag("magick:resize:10"))). \
      info(:dimensions).first).to eq 10
  end

  context "boolean resizes" do
    def dimensions(asset)
      return FastImage.new(asset).size
    end

    def rdim(val)
      return [
        val - 2, val + 2
      ]
    end

    it "allows 2x" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:2x")))
      expect(nd[0]).to(be_between(*rdim(og[0] * 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] * 2)))
    end

    it "allows 4x" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:4x")))
      expect(nd[0]).to(be_between(*rdim(og[0] * 4)))
      expect(nd[1]).to(be_between(*rdim(og[1] * 4)))
    end

    it "allows 1/2" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:1/2")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 2)))
    end

    it "allows 1/3" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:1/3")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 3)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 3)))
    end

    it "allows 2/3" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:2/3")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 3 * 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 3 * 2)))
    end

    it "allows 1/4" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:1/4")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 4)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 4)))
    end

    it "allows 2/4" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:2/4")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 4 * 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 4 * 2)))
    end

    it "allows 3/4" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:3/4")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 4 * 3)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 4 * 3)))
    end

    it "allows double" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:double")))
      expect(nd[0]).to(be_between(*rdim(og[0] * 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] * 2)))
    end

    it "allows quadruple" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:quadruple")))
      expect(nd[0]).to(be_between(*rdim(og[0] * 4)))
      expect(nd[1]).to(be_between(*rdim(og[1] * 4)))
    end

    it "allows half" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:half")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 2)))
    end

    it "allows one-third" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:one-third")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 3)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 3)))
    end

    it "allows two-thirds" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:two-thirds")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 3 * 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 3 * 2)))
    end

    it "allows one-fourth" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:one-fourth")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 4)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 4)))
    end

    it "allows two-fourths" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:two-fourths")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 4 * 2)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 4 * 2)))
    end

    it "allows three-fourts" do
      og = dimensions(@asset.pathname)
      nd = dimensions(get_asset(stub_tag("magick:three-fourths")))
      expect(nd[0]).to(be_between(*rdim(og[0] / 4 * 3)))
      expect(nd[1]).to(be_between(*rdim(og[1] / 4 * 3)))
    end
  end
end
