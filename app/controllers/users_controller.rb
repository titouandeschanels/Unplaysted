# frozen_string_literal: true

require "pry"
class UsersController < ApplicationController
  def spotify
    auth = request.env["omniauth.auth"]
    spotify_user = RSpotify::User.new(auth)
    @user = find_or_create_user(spotify_user)
    update_user_tokens(@user, spotify_user)
    set_session(@user, spotify_user)
    redirect_to user_path(@user)
  end

  def show
    @user = current_user
    @spotify_user = current_spotify_user
    @playlists = @spotify_user.playlists
    @tracks = @spotify_user.saved_tracks
  end

  private

  def find_or_create_user(spotify_user)
    User.find_or_create_by(spotify_id: spotify_user.id) do |user|
      user.assign_attributes(spotify_attributes(spotify_user))
    end
  end

  def spotify_attributes(spotify_user)
    {
      name: spotify_user.display_name,
      email: spotify_user.email,
      spotify_id: spotify_user.id,
      spotify_access_token: spotify_user.credentials["token"],
      token_expires_at: Time.current + spotify_user.credentials["expires_in"].to_i,
      spotify_refresh_token: spotify_user.credentials["refresh_token"]
    }
  end

  def update_user_tokens(user, spotify_user)
    user.update(
      spotify_access_token: spotify_user.credentials.token,
      spotify_refresh_token: spotify_user.credentials.refresh_token,
      token_expires_at: Time.zone.now + spotify_user.credentials.expires_in.to_i
    )
  end

  def set_session(user, spotify_user)
    session[:user_id] = user.id
    Current.user = user
    Current.spotify_user = spotify_user
  end
end
