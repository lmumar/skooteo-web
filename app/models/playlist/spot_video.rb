# frozen_string_literal: true

class Playlist::SpotVideo < SimpleDelegator
  attr_reader :spot

  def initialize(video, spot)
    super(video)
    @spot = spot
  end

  # Bug #11465 https://bugs.ruby-lang.org/issues/11465
  def respond_to_missing?(method, stuff)
    return false if method == :to_ary
    super
  end
end
