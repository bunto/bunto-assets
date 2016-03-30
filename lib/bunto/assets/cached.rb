# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Bunto
  module Assets
    class Cached < Sprockets::CachedEnvironment
      attr_reader :bunto
      attr_reader :parent

      def initialize(env)
        @parent = env
        @bunto = env.bunto
        super env
      end
    end
  end
end
