# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @user = current_user
    @spotify_user = current_spotify_user
  end
end
