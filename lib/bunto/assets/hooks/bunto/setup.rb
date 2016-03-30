# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Hooks.register :site, :after_reset do |bunto|
  Bunto::Assets::Env.new(bunto)

  excludes = Set.new(bunto.config["exclude"])
  bunto.sprockets.excludes.map(&excludes.method(:add))
  bunto.config["exclude"] = excludes.to_a
end
