# frozen_string_literal: true

require "rspotify"
class User < ApplicationRecord
  attribute :name, :string

  def spotify_user
    return nil unless spotify_access_token

    @spotify_user ||= begin
      refresh_spotify_token if token_expired?

      RSpotify::User.new(
        "id" => spotify_id,
        "credentials" => {
          "token" => spotify_access_token,
          "refresh_token" => spotify_refresh_token,
          "expires_at" => token_expires_at.to_i,
          "expires_in" => (token_expires_at - Time.current).to_i
        }
      )
    end
  end

  private

  def token_expired?
    token_expires_at.nil? || token_expires_at < Time.current
  end

  def refresh_spotify_token
    spotify_user = RSpotify::User.new(
      {
        "credentials" => {
          "token" => spotify_access_token,
          "refresh_token" => spotify_refresh_token,
          "access_refresh_callback" => callback_proc
        },
        "id" => spotify_id
      }
    )

    self.spotify_access_token = spotify_user.credentials["token"]
    self.token_expires_at = Time.current + spotify_user.credentials["expires_in"].to_i
    save!
  end

  def callback_proc
    proc do |new_access_token, token_lifetime|
      self.spotify_access_token = new_access_token
      self.token_expires_at = Time.current + token_lifetime
      save!
    end
  end
end
