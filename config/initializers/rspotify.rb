# frozen_string_literal: true

RSpotify.authenticate(
  Rails.application.credentials.dig(:spotify, :client_id),
  Rails.application.credentials.dig(:spotify, :client_secret)
)
