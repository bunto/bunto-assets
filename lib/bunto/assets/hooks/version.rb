# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init do
  self.version = Digest::MD5.hexdigest(
    asset_config.inspect
  )
end
