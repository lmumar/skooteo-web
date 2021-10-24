# frozen_string_literal: true

require 'rails_helper'

describe RecordLoader do
  include_context "creator"
  it 'loads' do
    result = GraphQL::Batch.batch do
      RecordLoader.for(User).load(creator.id)
    end
    expect(result).to eq(creator)
  end
end
