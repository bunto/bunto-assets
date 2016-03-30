require "rspec"
require "support/coverage"
require "luna/rspec/formatters/checks"
require "bunto/assets"
require "bunto"

Dir[File.expand_path("../../support/*.rb", __FILE__)].each do |v|
  require v
end
