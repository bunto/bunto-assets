# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Hooks.register :site, :pre_render do |bunto, payload|
  payload["assets"] = bunto.sprockets.to_liquid_payload
end
