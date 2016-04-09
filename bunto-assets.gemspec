$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))
require "bunto/assets/version"

Gem::Specification.new do |spec|
  spec.version = Bunto::Assets::VERSION
  spec.homepage = "http://github.com/bunto/bunto-assets/"
  spec.authors = ["Jordon Bedwell", "Aleksey V Zapparov", "Zachary Bush", "Suriyaa Kudo"]
  spec.email = ["jordon@envygeeks.io", "ixti@member.fsf.org", "zach@zmbush.com", "SuriyaaKudoIsc@users.noreply.github.com"]
  spec.files = %W(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Assets for Bunto"
  spec.name = "bunto-assets"
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description = spec.description = <<-DESC
    A Bunto plugin, that allows you to write javascript/css assets in
    other languages such as CoffeeScript, Sass, Less and ERB, concatenate
    them, respecting dependencies, minify and many more.
  DESC

  spec.add_runtime_dependency("sprockets", "~> 3.3")
  spec.add_runtime_dependency("sprockets-helpers", "~> 1.2")
  spec.add_runtime_dependency("fastimage", "~> 1.8")
  spec.add_runtime_dependency("bunto", "~> 1.0")

  # Fix vulnerability in uglifier
  ## See https://hakiri.io/projects/b9cabcd1429b01/stacks/09837afd893a17/builds/cd223dfdc2a35b/warnings?name=Code+Injection
  spec.add_runtime_dependency("uglifier, ">= 2.7.2")

  spec.add_development_dependency("nokogiri", "~> 1.6")
  spec.add_development_dependency("luna-rspec-formatters", "~> 3.5")
  spec.add_development_dependency("rspec", "~> 3.4")
end
