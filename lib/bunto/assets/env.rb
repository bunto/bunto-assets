# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Bunto
  module Assets
    class Env < Sprockets::Environment
      attr_reader :bunto, :used

      class << self
        attr_accessor :past
        def liquid_proxies
          Liquid::Tag::Proxies
        end
      end

      # ----------------------------------------------------------------------

      def excludes
        excludes = Set.new
        excludes << strip_path(in_cache_dir)
        excludes
      end

      # ----------------------------------------------------------------------

      def all_unparsed_assets
        @unparsed_assets ||= logical_paths.select do |(_, val)|
          val.start_with?(bunto.in_source_dir)
        end
      end

      # ----------------------------------------------------------------------

      def to_liquid_payload
        bunto.sprockets.all_unparsed_assets.each_with_object({}) do |(key, val), hash|
          hash[key] = Bunto::Assets::Liquid::Drop.new(
            val, bunto
          )
        end
      end

      # ----------------------------------------------------------------------

      def initialize(path, bunto = nil)
        bunto, path = path, nil if path.is_a?(Bunto::Site)
        @bunto = bunto
        @used = Set.new

        path ? super(path) : super()
        Hook.trigger :env, :init do |hook|
          hook.arity > 0 || 0 > hook.arity ? hook.call(self) : instance_eval(&hook)
        end
      end

      # ----------------------------------------------------------------------

      def liquid_proxies
        self.class.liquid_proxies
      end

      # ----------------------------------------------------------------------
      # Make sure a path falls withint our cache dir.
      # ----------------------------------------------------------------------

      def in_cache_dir(*paths)
        cache_dir = asset_config["cache"] || ".asset-cache"
        bunto.in_source_dir(cache_dir, *paths)
      end

      # ----------------------------------------------------------------------
      # Merged form of `#extra_assets`
      # ----------------------------------------------------------------------

      def all_assets
        Set.new(@used).merge extra_assets
      end

      # ----------------------------------------------------------------------
      # Assets you tell us you want to always compile, even if you do not
      # use them.  Just like Rails this is probably normally used.
      # ----------------------------------------------------------------------

      def extra_assets
        assets = asset_config["assets"] ||= []
        each_logical_path(*assets).map do |v|
          find_asset v
        end
      end

      # ----------------------------------------------------------------------

      def cdn?
        !dev? && asset_config.key?("cdn") && \
          asset_config["cdn"]
      end

      # ----------------------------------------------------------------------

      def baseurl
        ary = []

        ary << bunto.config["baseurl"] unless cdn? && asset_config["skip_baseurl_with_cdn"]
        ary <<  asset_config[ "prefix"] unless cdn? && asset_config[ "skip_prefix_with_cdn"]

        File.join(*ary.delete_if do |val|
          val.nil? || val.empty?
        end)
      end

      # ----------------------------------------------------------------------

      def dev?
        %W(development test).include?(Bunto.env)
      end

      # ----------------------------------------------------------------------

      def compress?(what)
        !!asset_config["compress"] \
          .fetch(what, false)
      end

      # ----------------------------------------------------------------------

      def asset_config
        bunto.config["assets"] ||= {}
      end

      # ----------------------------------------------------------------------

      def digest?
        !!asset_config["digest"]
      end

      # ----------------------------------------------------------------------
      # Prefix path prefixes the path with the baseurl and the cdn if it
      # exists and is in the right mode to use it.  Otherwise it will only use
      # the baseurl and asset prefix.  All of these can be adjusted.
      # ----------------------------------------------------------------------

      def prefix_path(path = nil)
        cdn = asset_config["cdn"]
        base_url = baseurl

        path_ = []
        path_ << base_url unless base_url.empty?
        path_ << path unless path.nil?

        url = cdn && cdn?? File.join(cdn, *path_) : File.join(*path_)
        url.chomp("/")
      end

      # ----------------------------------------------------------------------

      def cached
        Cached.new(self)
      end

      # ----------------------------------------------------------------------

      def write_all
        past = self.class.past ||= Set.new
        (@used.any?? all_assets : past).each do |obj|
          if past.add(obj) && path = as_path(obj)
            obj.write_to path
          end
        end
      end

      # ----------------------------------------------------------------------

      private
      def strip_path(path)
        path.sub(bunto.in_source_dir("/"), "")
      end

      # ----------------------------------------------------------------------

      private
      def as_path(v)
        path = digest?? v.digest_path : v.logical_path
        bunto.in_dest_dir(File.join(asset_config[ "prefix"], path))
      end

      # ----------------------------------------------------------------------

      class << self
        def context_patches
          Proc.new do
            alias _old_asset_path asset_path
            def asset_path(asset, _ = {})
              rtn = _old_asset_path asset

              return unless rtn
              path = environment.find_asset(resolve(asset))
              environment.parent.used.add(path)
              rtn
            end
          end
        end
      end
    end
  end
end
