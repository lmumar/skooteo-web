# frozen_string_literal: true

class PlaylistPolicy < ApplicationPolicy
  def destroy?
    record.spots.empty?
  end
end
