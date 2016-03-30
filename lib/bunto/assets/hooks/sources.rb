# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init do
  asset_config["sources"] ||= []

  asset_config["sources"].each do |path|
    append_path bunto.in_source_dir(path)
  end
end
