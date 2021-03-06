# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Bunto
  module Assets
    module Liquid
      class Tag
        module Defaults
          class Image
            def self.for?(tag)
              tag == "img" || tag == "image"
            end

            # ----------------------------------------------------------------
            # TODO: In 3.0 env needs to be enforced if this is not changed,
            #   for now it's not enforced to maintain the 2.0 API.
            # ----------------------------------------------------------------

            def initialize(args, asset, env = nil)
              @args = args
              @asset = asset
              @env = env
            end

            # ----------------------------------------------------------------

            def set!
              set_img_dimensions
              set_img_alt
            end

            # ----------------------------------------------------------------
            # TODO: 3.0 - Remove the `!@env`
            # ----------------------------------------------------------------

            private
            def set_img_alt
              if !@env || @env.asset_config["features"]["automatic_img_alt"]
                @args[:html] ||= {}
                unless @args[:html].key?("alt")
                  @args[:html]["alt"] = @asset.logical_path
                end
              end
            end

            # ----------------------------------------------------------------
            # TODO: 3.0 - Remove the `!@env`
            # ----------------------------------------------------------------

            private
            def set_img_dimensions
              if !@env || @env.asset_config["features"]["automatic_img_size"]
                dimensions = FastImage.new(@asset.filename).size
                return unless dimensions
                @args[:html] ||= {}

                @args[:html][ "width"] ||= dimensions.first
                @args[:html]["height"] ||= dimensions. last
              end
            end
          end
        end
      end
    end
  end
end
