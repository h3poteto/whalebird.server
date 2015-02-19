require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WhalebirdServer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << "#{config.root}/lib/extras"

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :utc

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.assets.enabled = true
    I18n.enforce_available_locales = false
    config.encoding = 'utf-8'
    config.generators do |g|
      g.test_frameworks = "rspec"
      g.controller_specs = false
      g.helper_specs = false
      g.view_specs = false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
