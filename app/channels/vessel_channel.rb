# frozen_string_literal: true

class VesselChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:id]

    stream_from "vessel_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
