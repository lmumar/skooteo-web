# frozen_string_literal: true

module Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :recordable

    after_create :track_created
    after_update :track_updated
  end

  attr_accessor :skip_event_tracking

  def track_created
    track_event :created
  end

  def track_updated
    track_event :updated, self.saved_changes.to_json
  end

  def track_event(action, details = nil)
    return if self.skip_event_tracking
    Event.create!(
      recordable: self, action: action,
      details: details, creator: Current.user
    )
  end
end
