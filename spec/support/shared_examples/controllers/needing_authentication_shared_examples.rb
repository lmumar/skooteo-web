# frozen_string_literal: true

RSpec.shared_examples 'needing authentication' do
  context 'needing authentication' do
    it 'redirects to the sign-in screen' do
      response = get :fake_index
      expect(response.location).to match('sessions/new')
    end
  end
end
