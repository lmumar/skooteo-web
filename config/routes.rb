# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
end if Rails.env.production?

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  root 'sessions#new'

  get 'sessions/destroy'

  resources :sessions, only: [ :new, :create ]
  namespace :admin do
    resources :companies do
      resources :billing_details, only: [ :new, :create ], controller: 'companies/billing_details'
      resources :video_play_logs, only: [ :new, :create ], controller: 'companies/video_play_logs'
      resources :credits, only: [ :index, :new, :create ], controller: 'companies/credits'
      resources :channels, only: [ :index ], controller: 'companies/channels'
      resources :channel_playlists, only: [ :index ], controller: 'companies/channel_playlists'
    end
    resources :users
    resources :videos do
      member do
        post 'approve'
        post 'reject'
      end
    end
  end

  namespace :fleet do
    namespace :admin do
      resources :videos, only: [ :index ] do
        resources :approvals, only: [ :create ], controller: 'videos/approvals'
        resources :rejections, only: [ :create ], controller: 'videos/rejections'
      end
    end
    resources :channels, only: [ :index ]
    resources :channel_playlists, only: [ :index ]
    resources :channel_playlist_assignments
    resources :vessels
    resources :vessel_route_schedules, only: %i[ index create ] do
      collection do
        post 'new_schedule'
      end

      member do
        post 'activate'
        post 'deactivate'
      end
    end
    resources :vessel_routes, except: %i[destroy]
    resources :vessel_schedules, only: [ :index, :show ]
    resources :vessel_waypoints, only: [ :new ]
    resources :playlist_assignments, only: %i[ new create ]
    resources :playlists do
      member do
        post 'set_default'
      end
    end
    resources :onboarding_playlist, controller: 'playlists'
    resources :offboarding_playlist, controller: 'playlists'
    resources :videos
    resources :playlist_videos do
      member do
        post 'set_play_order'
      end
    end

    get 'vessel_media_settings/edit/:vessel_id/:route_id',
      to: 'vessel_media_settings#edit', as: :edit_vessel_media_settings

    post 'save/:id',
      to: 'vessel_media_settings#save', as: :save_vessel_media_settings
  end

  namespace :media do
    resources :campaigns do
      collection do
        post 'set_playlist'
      end
    end
    resources :playlists do
      member do
        post 'archive'
        post 'set_default'
      end
    end
    resources :spots do
      collection do
        post 'calculate'
      end
    end
    resources :videos
    resources :playlist_assignments
    resources :playlist_videos do
      member do
        post 'set_play_order'
      end
    end
  end

  namespace :content_provider do
    resources :videos
  end

  namespace :spots do
    resources :vehicle_route_schedules, only: [ ], controller: '/media/spots/vehicle_route_schedules' do
      collection do
        post 'search'
      end
    end
  end

  namespace :users do
    resource :password_reset, only: [ :new, :create ], controller: '/users/password_reset'
  end

  mount Sidekiq::Web => '/sidekiq'
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
