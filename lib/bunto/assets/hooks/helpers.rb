# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "sprockets/helpers"

Bunto::Assets::Hook.register :env, :init do
  Sprockets::Helpers.configure do |config|
    config.prefix = prefix_path
    config.digest = digest?
  end
end
