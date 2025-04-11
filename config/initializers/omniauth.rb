# frozen_string_literal: true

require "rspotify/oauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify,
           Rails.application.credentials.dig(:spotify, :client_id),
           Rails.application.credentials.dig(:spotify, :client_secret),
           scope: "user-read-email playlist-modify-public user-library-read user-library-modify"
end

OmniAuth.config.allowed_request_methods = [:post, :get]
