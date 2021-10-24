# frozen_string_literal: true

if ENV['FIREBASE'].present? && File.exists?(ENV['FIREBASE_CREDENTIALS'])
  FirebaseCloudMessenger.credentials_path = ENV['FIREBASE_CREDENTIALS']
else
  FirebaseCloudMessenger.credentials_path = '/opt/skooteo/skooteo-firebase.json'
end
