# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
require "nokogiri"

describe Bunto::Assets::Liquid::Drop do
  subject { described_class }
  before :all do
    @site = stub_bunto_site
    @env = Bunto::Assets::Env.new(@site)
    @renderer = @site.liquid_renderer
    @register = {
      :registers => {
        :site => @site
      }
    }

    @site.process
  end

  def render(data)
    payload = @site.site_payload.merge("assets" => @env.to_liquid_payload)
    @renderer.file(__FILE__).parse(data).render!(payload, @register)
  end

  def fragment(html)
    Nokogiri::HTML.fragment(html).children. \
      first
  end

  it "allows you to get the content type" do
    result = "image/png"
    data = "{{ assets['ruby.png'].content_type }}"
    expect(render(data)).to(eq(result))
  end

  it "allows the user to pull out an asset" do
    data = "{{ assets['bundle.css'] }}"
    result = "Bunto::Assets::Liquid::Drop"
    expect(render(data)).to(eq(result))
  end

  context "with an image" do
    it "allows the user to get the width" do
      data = "{{ assets['ruby.png'].width }}"
      expect(render(data)).to(eq("62"))
    end

    it "allows the user to get the height" do
      data = "{{ assets['ruby.png'].height }}"
      expect(render(data)).to(eq("62"))
    end
  end
end
