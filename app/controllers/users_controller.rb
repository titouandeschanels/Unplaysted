# frozen_string_literal: true

class UsersController < ApplicationController
  def spotify
    auth = request.env["omniauth.auth"]
    spotify_user = RSpotify::User.new(auth)
    @user = find_or_create_user(RSpotify::User.new(auth))

    @user.update(
      spotify_access_token: spotify_user.credentials.token,
      spotify_refresh_token: spotify_user.credentials.refresh_token,
      token_expires_at: Time.now + spotify_user.credentials.expires_in.to_i
    )

    session[:user_id] = @user.id
    Current.user = @user
    Current.spotify_user = spotify_user
    redirect_to user_path(@user)
  end

  def show
    @user = current_user
    @spotify_user = current_spotify_user
  end

  private

  def find_or_create_user(spotify_user)
    User.find_or_create_by(spotify_id: spotify_user.id) do |user|
      user.name = spotify_user.display_name
      user.email = spotify_user.email
      user.spotify_id = spotify_user.id
      user.spotify_access_token = spotify_user.credentials["token"]
      user.token_expires_at = Time.current + spotify_user.credentials["expires_in"].to_i
      user.spotify_refresh_token = spotify_user.credentials["refresh_token"]
    end
  end
end
