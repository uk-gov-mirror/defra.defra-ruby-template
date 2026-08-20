# frozen_string_literal: true

require "defra_ruby_template/version"

module DefraRubyTemplate
  module Rails
    class Engine < ::Rails::Engine
      # Rails only builds a host app's own assets automatically, so anything the
      # layout links to has to be named here. Files the stylesheet references
      # (the fonts, the crest) don't need naming - Sprockets finds those itself.
      initializer "defra_ruby_template.assets.precompile" do |app|
        app.config.assets.precompile += %w[
          defra_ruby_template_supported.js
          manifest.json
          favicon.ico
          favicon.svg
          govuk-icon-mask.svg
          govuk-icon-180.png
          govuk-opengraph-image.png
        ]
      end
    end
  end
end
