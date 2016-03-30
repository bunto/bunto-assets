# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Bunto
  module Assets
    module Config
      DefaultSources = %W(
        _assets/css _assets/stylesheets
        _assets/images _assets/img _assets/fonts
        _assets/javascripts _assets/js
      ).freeze

      # ----------------------------------------------------------------------

      Development = {
        "skip_baseurl_with_cdn" => false,
        "skip_prefix_with_cdn"  => false,
        "prefix"    => "/assets",
        "digest"    => false,
        "assets"    => [],

        "compress"  => {
          "css"     => false,
          "js"      => false
        },

        "features" => {
          "automatic_img_alt"  => true,
          "automatic_img_size" => true,
          "liquid" => false
        }
      }.freeze

      # ----------------------------------------------------------------------

      Production = Development.merge({
        "digest"    => true,
        "compress"  => {
          "css"     => true,
          "js"      => true
        }
      }).freeze

      # ----------------------------------------------------------------------

      def self.merge_sources(bunto, config)
        config["sources"] ||= []
        return if config["sources"].grep(/\A\s*_assets\/?\s*\Z/).size > 0
        sources = DefaultSources + config["sources"].to_a

        config["sources"] = Set.new(sources.map do |val|
          bunto.in_source_dir(val)
        end)
      end

      # ----------------------------------------------------------------------

      def self.defaults
        if %W(development test).include?(Bunto.env)
          then Development else Production
        end
      end

      # ----------------------------------------------------------------------

      def self.merge(new_hash, old_hash = defaults)
        old_hash.merge(new_hash) do |_, old_val, new_val|
          old_val.is_a?(Hash) && new_val.is_a?(Hash) ? merge(new_val, old_val) : new_val
        end
      end
    end
  end
end
