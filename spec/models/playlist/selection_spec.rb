# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist::Selection do
  subject { described_class }

  include_context 'shared segmenting context' do
    let(:tests) do
      [
        {
          tests: {
            videos: [
              mkvideo(90, 2),
              mkvideo(61, 2),
            ],
            booked_spots: 1
          },
          wants: {
            expects: [],
            consumed_spots: 0
          }
        },
        {
          tests: {
            videos: [
              mkvideo(90, 2),
              mkvideo(61, 2),
            ],
            booked_spots: 9
          },
          wants: {
            expects: [90, 61, 90, 61],
            consumed_spots: 8
          }
        },
        {
          tests: {
            videos: [
              mkvideo(90, 2),
              mkvideo(61, 1),
            ],
            booked_spots: 13
          },
          wants: {
            expects: [90, 61, 90, 61, 90, 61, 90, 61, 61],
            consumed_spots: 13
          }
        },
        {
          tests: {
            videos: [
              mkvideo('2A1', 2),
              mkvideo('2A2', 2),
              mkvideo('1A3', 1),
            ],
            booked_spots: 15
          },
          wants: {
            expects: ['2A1', '2A2', '1A3', '2A1', '2A2', '1A3', '2A1', '2A2', '1A3'],
            consumed_spots: 15
          }
        },
        {
          tests: {
            videos: [
              mkvideo('4B1', 4),
              mkvideo('2B2', 2),
            ],
            booked_spots: 25
          },
          wants: {
            expects: ['4B1', '2B2', '4B1', '2B2', '4B1', '2B2', '4B1', '2B2'],
            consumed_spots: 24
          }
        },
        {
          tests: {
            videos: [
              mkvideo('1C1', 1),
              mkvideo('3C2', 3),
              mkvideo('3C3', 3),
            ],
            booked_spots: 30
          },
          wants: {
            expects: ['1C1', '3C2', '3C3', '1C1', '3C2', '3C3', '1C1', '3C2', '3C3', '1C1', '3C2', '3C3', '1C1', '1C1'],
            consumed_spots: 30
          }
        },
        {
          tests: {
            videos: [
              mkvideo(35, 2),
              mkvideo(44, 2),
              mkvideo(45, 3),
              mkvideo(57, 2),
              mkvideo(58, 3),
              mkvideo(59, 2)
            ],
            booked_spots: 14
          },
          wants: {
            expects: [35, 44, 45, 57, 58, 59],
            consumed_spots: 14
          }
        }
      ]
    end
  end

  describe '.call' do
    it 'selects the appropriate number of videos for the booked spots' do
      service = subject.new
      tests.each do |attrs|
        tests = attrs[:tests]
        wants = attrs[:wants]
        result = service.call(tests[:videos], tests[:booked_spots])
        expect(result.sum(&:consumable_spot_count)).to eq(wants[:consumed_spots])
        expect(result.map(&:id)).to eq(wants[:expects])
      end
    end
  end
end
