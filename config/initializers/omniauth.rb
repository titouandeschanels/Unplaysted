# frozen_string_literal: true

require "rspotify/oauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify,
           Rails.application.credentials.dig(:spotify, :client_id),
           Rails.application.credentials.dig(:spotify, :client_secret),
           scope: %w[
             user-read-email
             user-library-read
             user-library-modify
             user-read-private
             user-read-currently-playing
             playlist-read-private
             playlist-read-collaborative
           ].join(" ")
end

OmniAuth.config.allowed_request_methods = [:post, :get]
