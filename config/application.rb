# frozen_string_literal: true

require_relative 'boot'

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    require_dependency Rails.root.join('lib/skooteo')
    require_dependency Rails.root.join('lib/skooteo/avatar/letter')
    require_dependency Rails.root.join('lib/skooteo/patch')
    require_dependency Rails.root.join('lib/skooteo/will_paginate/link_renderer')

    # Initialize configuration defaults for originally generated Rails version.
    config.action_cable.mount_path = '/cable'
    config.load_defaults 6.1
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.generators.system_tests = nil
    config.active_job.queue_adapter = :sidekiq

    def default_vehicle_properties!(vehicle_type = 'Vessel')
      default_property_key = self.config.skooteo[:default_vehicle_properties_key]
      config_for("properties/#{default_property_key}").fetch(vehicle_type.downcase.to_sym)
    end

    config.action_mailer.smtp_settings = Rails.application.credentials.smtp if Rails.env.production?
  end
end
