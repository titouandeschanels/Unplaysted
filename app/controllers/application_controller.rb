# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user

  private

  def set_current_user
    return unless Current.user.nil?

    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
    return unless Current.user

    Current.spotify_user = Current.user.spotify_user
  end

  def current_user
    Current.user
  end

  def current_spotify_user
    Current.spotify_user
  end
end
