# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Bunto::Assets::Hook.register :env, :init do
  context_class.class_eval(
    &self.class.context_patches
  )
end
