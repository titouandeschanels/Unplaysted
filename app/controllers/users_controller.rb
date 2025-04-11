# frozen_string_literal: true

class UsersController < ApplicationController
  def spotify
    spotify_user = RSpotify::User.new(request.env["omniauth.auth"])
    @user = find_or_create_user(spotify_user)
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def find_or_create_user(spotify_user)
    User.find_or_create_by(spotify_id: spotify_user.id) do |user|
      user.name = spotify_user.display_name
      user.email = spotify_user.email
      user.spotify_id = spotify_user.id
    end
  end
end
