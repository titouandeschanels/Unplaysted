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
    @playlists = @spotify_user.playlists.reverse
  end

  def playlist
    @user = current_user
    @spotify_user = current_spotify_user
    @playlists = @spotify_user.playlists

    @playlist = if params[:id]
                  @playlists.find { |playlist| playlist.id == params[:id] }
                else
                  @playlists.first
                end
  end

  def play
    @user = current_user
    @spotify_user = current_spotify_user
    @playlists = @spotify_user.playlists

    @playlist = if params[:id]
                  @playlists.find { |playlist| playlist.id == params[:id] }
                else
                  @playlists.first
                end

    @tracks = @playlist.tracks

    return unless request.post?

    track_id = params[:track_id]
    track_uri = track_id.start_with?("spotify:track:") ? track_id : "spotify:track:#{track_id}"

    # Find the index of the current track
    current_index = @tracks.find_index { |track| track.id == track_id.gsub("spotify:track:", "") }
    session[:current_track_index] = current_index

    @spotify_user.player.play_track(track_uri)
  end

  def next_track
    @user = current_user
    @spotify_user = current_spotify_user
    @playlists = @spotify_user.playlists

    @playlist = if params[:id]
                  @playlists.find { |playlist| playlist.id == params[:id] }
                else
                  @playlists.first
                end

    @tracks = @playlist.tracks

    if request.post?
      # Get the current track index from the session or default to 0
      current_index = session[:current_track_index] || 0

      # Move to the next track, or back to the beginning if we're at the end
      next_index = (current_index + 1) % @tracks.length
      session[:current_track_index] = next_index

      # Get the next track
      next_track = @tracks[next_index]
      track_uri = "spotify:track:#{next_track.id}"

      # Play the next track
      @spotify_user.player.play_track(track_uri)
    end

    redirect_to play_user_path(@user, id: @playlist.id)
  end

  def destroy
    session[:user_id] = nil
    Current.user = nil
    Current.spotify_user = nil
    redirect_to root_path, notice: "Vous avez été déconnecté avec succès."
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
