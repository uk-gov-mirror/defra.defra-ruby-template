# frozen_string_literal: true

# rubocop:disable Gemspec/RequiredRubyVersion

require_relative "lib/defra_ruby_template/version"

Gem::Specification.new do |spec|
  spec.name          = "defra_ruby_template"
  spec.version       = DefraRubyTemplate::VERSION
  spec.authors       = ["Toby Privett"]
  spec.email         = ["toby@snaplab.co.uk"]

  spec.summary       = "DEFRA Ruby Template"
  spec.description   = "Adds the GOVUK frontend to a Rails application that uses the Asset Pipeline."
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-template"
  spec.license       = "The Open Government Licence (OGL) Version 3"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files = Dir["{app,bin,config,lib,node_modules,vendor}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

# rubocop:enable Gemspec/RequiredRubyVersion
