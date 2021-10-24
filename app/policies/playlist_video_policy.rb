# frozen_string_literal: true
class PlaylistVideoPolicy < ApplicationPolicy
  class << self
    def can_destroy? record
      !record.playlist.default? || record.playlist.videos.size > 1
    end
  end

  def destroy?
    self.class.can_destroy? record
  end
end
