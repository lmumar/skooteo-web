require 'ostruct'

RSpec.shared_context 'shared segmenting context' do
  def mkvideo(id, spot_count)
    OpenStruct.new(id: id, consumable_spot_count: spot_count)
  end
end

