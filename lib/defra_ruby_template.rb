# frozen_string_literal: true

require "defra_ruby_template/version"

module DefraRubyTemplate
  module Rails
    class Engine < ::Rails::Engine
      # Sprockets only precompiles engine assets that are named explicitly. These
      # are the ones nothing in a host application references directly:
      #
      #   defra_ruby_template_supported.js  included by the layout
      #   manifest.json                     linked by the layout, and in turn
      #                                     references the icons below
      #   the icons                         linked by the layout and the manifest
      #   govuk-crest.svg                   image-url() in the footer stylesheet
      STANDALONE_ASSETS = %w[
        defra_ruby_template_supported.js
        manifest.json
        favicon.ico
        favicon.svg
        govuk-crest.svg
        govuk-icon-mask.svg
        govuk-icon-180.png
        govuk-icon-192.png
        govuk-icon-512.png
        govuk-opengraph-image.png
      ].freeze

      # The GDS Transport font filenames carry a content hash, so match on their
      # shape rather than pinning names that change with every govuk-frontend
      # release. font-url() in the stylesheets is what asks for them.
      FONTS = %r{\A(?:fonts/)?(?:bold|light)-[0-9a-f]+-v\d+\.woff2?\z}

      initializer "defra_ruby_template.assets.precompile" do |app|
        app.config.assets.precompile += STANDALONE_ASSETS
        app.config.assets.precompile << FONTS
      end
    end
  end
end
