# frozen_string_literal: true

RSpec.shared_context 'creator' do
  let(:creator)                 { create :sysusr }
  let(:creator_advertiser)      { create :acmejohn }
  let(:creator_fleet_operator)  { create :nemo }
end
