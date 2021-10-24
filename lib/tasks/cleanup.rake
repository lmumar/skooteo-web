# frozen_string_literal: true

namespace :cleanup do
  namespace :sidekiq do
    require "sidekiq/api"

    desc "Skooteo | Clean-up all sidekiq sets, should only be run in development mode"
    task sets: :environment do
      return unless Rails.env.development?

      Sidekiq::RetrySet.new.clear
      Sidekiq::ScheduledSet.new.clear
      Sidekiq::Stats.new.reset
      Sidekiq::DeadSet.new.clear

      puts "done."
    end
  end
end
