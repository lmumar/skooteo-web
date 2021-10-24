# frozen_string_literal: true
module Confirmable
  extend ActiveSupport::Concern

  included do
    before_create :generate_confirmation_token
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(5)
  end

  def confirmed?
    self.confirmed_at.present?
  end

  def confirmed!(time = Time.now)
    return self if self.confirmed?
    self.confirmed_at = time
    self.save!
  end

  def confirmation_sent?
    self.confirmation_sent_at.present?
  end

  def confirmation_sent!(time = Time.now)
    return self if self.confirmation_sent?
    self.confirmation_sent_at = time
    self.save!
  end
end
