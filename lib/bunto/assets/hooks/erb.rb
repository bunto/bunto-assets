# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init, :early do
  self.config = hash_reassoc(config, :engines) do |hash|
    hash.delete(
      ".erb"
    )

    hash
  end
end
