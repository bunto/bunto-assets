# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init do
  if compress?("css")
    self.css_compressor = :sass
  end

  if compress?("js")
    try_require "uglifier" do
      self.js_compressor = :uglify
    end
  end
end
