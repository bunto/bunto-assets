# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Hooks.register :site, :post_write do |bunto|
  bunto.sprockets.write_all
end
