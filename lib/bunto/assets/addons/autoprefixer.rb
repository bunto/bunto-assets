# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

try_require_if_javascript "autoprefixer-rails" do
  Bunto::Assets::Hook.register :env, :init do |env|
    AutoprefixerRails.install(env, env.asset_config[
      "autoprefixer"
    ])
  end
end
