module Bunto
  module Assets
    module Processors
      class Liquid
        FOR = %W(
          text/css text/sass text/less application/javascript
          text/scss text/coffeescript text/javascript).freeze
        EXT = %W(.liquid .js.liquid .css.liquid .scss.liquid).freeze

        # --------------------------------------------------------------------

        def self.call(context, bunto = context[:environment].bunto)
          if context[:environment].parent.asset_config["features"]["liquid"] || \
              File.extname(context[:filename]) == ".liquid"

            payload_ = bunto.site_payload
            renderer = bunto.liquid_renderer.file(context[:filename])
            context[:data] = renderer.parse(context[:data]).render! payload_, :registers => {
              :site => bunto
            }
          end
        end
      end
    end
  end
end

# ----------------------------------------------------------------------------
# There might be a few missing, if there is please do let me know.
# ----------------------------------------------------------------------------

Bunto::Assets::Processors::Liquid::EXT.each do |ext|
  Sprockets.register_engine(
    ext, Bunto::Assets::Processors::Liquid
  )
end

Bunto::Assets::Processors::Liquid::FOR.each do |val|
  Sprockets.register_preprocessor(
    val, Bunto::Assets::Processors::Liquid
  )
end
