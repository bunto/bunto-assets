# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Kernel
  def try_require(file)
    require file
    if block_given?
      yield
    end
  rescue LoadError
    return nil
  end

  # --------------------------------------------------------------------------

  def try_require_if_javascript(file)
    ["execjs", file].map(&method(:require))
    if block_given?
      yield
    end
  rescue LoadError, ExecJS::RuntimeUnavailable
    Bunto.logger.debug("ExecJS, JS Runtime or `#{file}' not available." \
      " Skipping the loading of libraries.")
    return
  end
end
