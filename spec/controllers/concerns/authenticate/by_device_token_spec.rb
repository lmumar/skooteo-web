# frozen_string_literal: true

require 'rails_helper'

class FakesController < ApplicationController; end

describe Authenticate::ByDeviceToken, type: :controller do
  controller FakesController do
    def fake_index
      render json: {}
    end
  end

  before do
    routes.draw { get 'fake_index' => 'fakes#fake_index' }
  end

  describe 'authenticate' do
    context 'authenticated' do
      include_context 'creator'

      before do
        Current.set(user: creator) do
          vehicle = create :vehicle, :active_service
          request.headers['Authorization'] = vehicle.device_token
        end
      end

      it 'returns a success status' do
        expect(get(:fake_index)).to have_http_status(:ok)
      end
    end
    it_behaves_like 'needing authentication'
  end
end
