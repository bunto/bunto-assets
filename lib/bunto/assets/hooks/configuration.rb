# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init, :early do
  bunto.config["assets"] = Bunto::Assets::Config.merge(asset_config)
  Bunto::Assets::Config.merge_sources(
    bunto, asset_config
  )
end
