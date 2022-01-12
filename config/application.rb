require_relative 'boot'

require 'rails/all'

require 'grover'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Abtt
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Eastern Time (US & Canada)'
    
    config.to_prepare do
      Devise::SessionsController.layout "application"
      Devise::PasswordsController.layout "application"
    end

    config.middleware.use Grover::Middleware
    Grover.configure do |config|
      config.use_png_middleware = false
      config.use_jpeg_middleware = false
      config.use_pdf_middleware = false
    end
  end
end
