# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Bunto::Assets::Liquid::Tag::Parser do
  let(:escape_error) { subject::UnescapedColonError }
  let( :proxy_error) { subject::UnknownProxyError   }
  subject { described_class }

  before :each, :proxies => true do
    allow(Bunto::Assets::Liquid::Tag::Proxies).to receive(:all).and_return(Set.new([{
      :cls=> :internal,
      :args=>[
        "resize",
        "@2x"
      ],

      :name=>[
        :magick,
        "magick"
      ],

      :tags=>[
        :img,
        "img"
      ],
    }]))
  end

  def fragment(html)
    Nokogiri::HTML.fragment(html)
  end

  it "properly parses syntax", :proxies => true do
    input = "hello.jpg lol key:value magick:2x magick:resize:2x2"
    expect(subject.new(input, "img").args).to match({
      :file=>"hello.jpg",
      :magick => {
        :resize => "2x2",
        :"2x" => true
      },

      :html => {
        "lol"=>true,
        "key"=>"value"
      }
    })
  end

  it "works with loops and normal values" do
    site = stub_bunto_site
    input = <<-LIQUID
      {% assign my_var = "1,2,3" | split: ","  %}
      {% for n in my_var %}
        {% img ruby.png id:"{{ n }}" %}
      {% endfor %}
    LIQUID

    result = fragment(site.liquid_renderer.file("(file)").parse(input).render( \
      site.site_payload, :registers => { :site => site })).xpath("img")

    expect(result.size).to(eq(3))
    expect(result[0].attr("id")).to(eq("1"))
    expect(result[1].attr("id")).to(eq("2"))
    expect(result[2].attr("id")).to(eq("3"))
  end

  context do
    before(:each) { site.process }; let(:site) { stub_bunto_site }
    it "works with loops and file names" do
      result = fragment(site.pages.first.output).css("img.loop-test")
      expect(result.size).to eq 3
      expect(result[0].attr(:src)).to eq "/assets/ruby1.png"
      expect(result[1].attr(:src)).to eq "/assets/ruby2.png"
      expect(result[2].attr(:src)).to eq "/assets/ruby3.png"
    end
  end

  it "processes liquid when asked to" do
    input = "img.jpg?version='{{ bunto.version }}' env:'{{ bunto.environment }}'"
    result = subject.new(input, "img").parse_liquid(build_context)
    expect(result.to_h).to(include(:file => "img.jpg?version=#{Bunto::VERSION}"))
    expect(result[:html]).to(include("env" => Bunto.env))
  end

  it "raises an error if there is no proxy available" do
    input = "img.jpg sprockets:unknown:hello"
    expect_it = expect { subject.new(input, "img") }
    expect_it.to(raise_error(proxy_error))
  end

  it "makes like 'proxy' argument an HTML argument if there is no proxy key" do
    input = "img.jpg sprockets:unknown"
    expect(subject.new(input, "img").args[:html]["sprockets"]). \
      to(eq("unknown"))
  end

  it "allows boolean proxy arguments", :proxies => true do
    expect(subject.new("img.jpg magick:2x", "img").args[:magick][:"2x"]). \
      to(eq(true))
  end

  it "does not allocate boolean arguments as proxy values", :proxies => true do
    input = "img.jpg magick:2x:raise"
    expect_it = expect { subject.new(input, "img") }
    expect_it.to(raise_error(proxy_error))
  end

  it "expects escaping more than one colon with quotes" do
    input = "hello.jpg sprockets:accept:'image:gif'"
    expect_it = expect { subject.new(input, "img") }
    expect_it.to(raise_error(escape_error))
  end

  it "expects escaping more than one colon without quotes" do
    input = "hello.jpg sprockets:acpet:image:gif"
    expect_it = expect { subject.new(input, "img") }
    expect_it.to(raise_error(escape_error))
  end

  it "allows escaping inside of quotes" do
    input = 'hello.jpg sprockets:accept:"image\\\:gif"'
    expect(subject.new(input, "img")[:sprockets][:accept]). \
      to(eq("image:gif"))
  end

  it "allows quoting the entire argument" do
    input = "hello.jpg 'sprockets:accept:image/gif'"
    expect(subject.new(input, "img").args[:sprockets][:accept]). \
      to(eq("image/gif"))
  end

  it "allows quoting only fragments of an argument" do
    input = "hello.jpg sprockets:accept:'image/gif'"
    expect(subject.new(input, "img").args[:sprockets][:accept]). \
      to(eq("image/gif"))
  end
end
