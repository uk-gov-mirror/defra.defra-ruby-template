# frozen_string_literal: true

require "rake"
require "rspec"

# Load the Rakefile
load File.expand_path("../../Rakefile", __dir__)

RSpec.describe "Rake tasks" do
  def root
    File.expand_path("../..", __dir__)
  end

  def vendored(path)
    File.join(root, "vendor/assets", path)
  end

  def tasks
    %w[clean minified_css fonts images manifest stylesheets javascripts]
  end

  before do
    (tasks + %w[assets]).each { |task| Rake::Task[task].reenable }
  end

  %w[clean minified_css fonts images manifest stylesheets javascripts].each do |task|
    describe task do
      it "runs without error" do
        expect { Rake::Task[task].invoke }.not_to raise_error
      end
    end
  end

  describe "assets" do
    before { Rake::Task["assets"].invoke }

    it "runs without error" do
      expect { Rake::Task["assets"].invoke }.not_to raise_error
    end

    it "vendors a single asset set, with no rebrand split", :aggregate_failures do
      expect(Dir.exist?(vendored("assets/rebrand"))).to be false
      expect(Dir.exist?(vendored("images/rebrand"))).to be false
    end

    it "removes assets that govuk-frontend no longer ships" do
      %w[
        stylesheets/all.scss
        images/govuk-crest.png
        images/govuk-crest-2x.png
      ].each { |path| expect(File.exist?(vendored(path))).to be false }
    end

    describe "the stylesheet entry point" do
      subject(:scss) { File.read(vendored("stylesheets/defra_ruby_template.scss")) }

      it "imports govuk-frontend's index, not its deprecated all", :aggregate_failures do
        expect(scss).to include('@import "index.import"')
        expect(scss).not_to include('@import "all"')
      end

      it "does not carry govuk-frontend's import-using-all deprecation warning" do
        expect(scss).not_to include("import-using-all")
      end

      it "points the image and font URL helpers at the matching Rails helper", :aggregate_failures do
        expect(scss).to match(/\$govuk-image-url-function:\s*"image-url"/)
        expect(scss).to match(/\$govuk-font-url-function:\s*"font-url"/)
      end
    end

    describe "the govuk-frontend-supported snippet" do
      subject(:js) { File.read(vendored("javascripts/defra_ruby_template_supported.js")) }

      it "sets both classes govuk-frontend gates its CSS and JavaScript on", :aggregate_failures do
        expect(js).to include("js-enabled")
        expect(js).to include("govuk-frontend-supported")
      end
    end

    describe "the web app manifest" do
      subject(:manifest) { File.read(vendored("assets/manifest.json.erb")) }

      it "resolves its icons through the asset pipeline", :aggregate_failures do
        expect(manifest).to include('<%= asset_path "favicon.ico" %>')
        expect(manifest).not_to include('"images/')
      end
    end
  end
end
