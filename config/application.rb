require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Fcc
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.encoding = "utf-8"
    config.autoload_paths += %W(lib lib/paperclip app/models/ckeditor)
    config.i18n.load_path += Dir[Rails.root.join("my", 'config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.locale = :en
    config.paths['config/routes.rb'] << Rails.root.join("config/routes/admin.rb")
    config.paths['config/routes.rb'] << Rails.root.join("config/routes/user.rb")
    config.action_view.field_error_proc = proc { |input, instance| input }
  end
end
