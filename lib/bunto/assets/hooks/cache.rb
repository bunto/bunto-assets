# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init do
  cache_dir = asset_config.fetch("cache", ".asset-cache")

  if cache_dir
    self.cache = Sprockets::Cache::FileStore.new(
      bunto.in_source_dir(cache_dir)
    )
  end
end
