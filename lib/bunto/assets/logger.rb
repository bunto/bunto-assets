# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Bunto
  module Assets
    class Logger
      PREFIX = "Bunto Assets:"

      def log
        @_log ||= Bunto.logger
      end

      # ----------------------------------------------------------------------
      # Log Level: 1
      # ----------------------------------------------------------------------

      def warn(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.warn(PREFIX, msg)
      end

      # ----------------------------------------------------------------------
      # Log Level: 1
      # ----------------------------------------------------------------------

      def error(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.error(PREFIX, msg)
      end

      # ----------------------------------------------------------------------
      # Log Level: 2
      # ----------------------------------------------------------------------

      def info(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.info(PREFIX, msg)
      end

      # ----------------------------------------------------------------------
      # Log Level: 3
      # ----------------------------------------------------------------------

      def debug(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.debug(PREFIX, msg)
      end

      # ----------------------------------------------------------------------

      def log_level=(*)
        raise RuntimeError, "Please set log levels on Bunto.logger"
      end
    end
  end
end
