# frozen_string_literal: true

module ApplicationHelper
  def format_duration(duration_ms)
    total_seconds = (duration_ms / 1000).round
    minutes = total_seconds / 60
    seconds = total_seconds % 60
    format("%d:%02d", minutes, seconds)
  end
end
