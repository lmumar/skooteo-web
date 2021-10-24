# frozen_string_literal: true

FactoryBot.define do
  sequence(:company_name)  { |n| "acme#{n}" }
  sequence(:email)         { |n| "user#{n}@example.org" }
  sequence(:first_name)    { |n| "John#{n}" }
  sequence(:last_name)     { |n| "Doe#{n}" }
  sequence(:playlist_name) { |n| "Playlist#{n}" }
  sequence(:route_name)    { |n| "route#{n}" }
  sequence(:username)      { |n| "user#{n}" }
  sequence(:vessel_name)   { |n| "Nautilus #{n}" }
  sequence(:video_name)    { |n| "Video #{n}" }
end
