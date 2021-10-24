# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist::Segmenting do
  subject { described_class.new }

  describe '.call' do
    include_context 'shared segmenting context' do
      let(:segments_count) { 10 }
      let(:tests) do
        [
          {
            tests: [
              [
                mkvideo('2A1', 2),
                mkvideo('2A2', 2),
                mkvideo('1A3', 1),
                mkvideo('2A1', 2),
                mkvideo('2A2', 2),
                mkvideo('1A3', 1),
                mkvideo('2A1', 2),
                mkvideo('2A2', 2),
                mkvideo('1A3', 1)
              ],
              [
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                mkvideo('4B1', 4),
                mkvideo('2B2', 2)
              ],
              [
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('1C1', 1),
              ]
            ],
            wants: [
              ['2A1', '4B1', '1C1'],
              ['2A2', '2B2', '3C2'],
              ['1A3', '4B1', '3C3'],
              ['2A1', '2B2', '1C1', '2A2'],
              ['4B1', '3C2'],
              ['1A3', '2B2', '3C3', '2A1'],
              ['4B1', '1C1', '2A2'],
              ['2B2', '3C2', '1A3', '3C3'],
              ['1C1', '3C2', '3C3'],
              ['1C1', '1C1']
            ]
          }
        ]
      end
    end

    it 'segments playlists' do
      tests.each do |attrs|
        tests = attrs[:tests]
        wants = attrs[:wants]
        result = subject.call(tests, segments_count)
        result = result.inject([]) do |nlist, playlist|
          m = playlist.map { |pl| pl&.id }
          nlist << m
        end
        expect(result).to eq(wants)
      end
    end
  end

  describe '.normalize_playlist_lens_base_on_max' do
    include_context 'shared segmenting context' do
      let(:tests) {
        [
          {
            tests: [
              [
                mkvideo('1A1', 1)
              ],
              [
                mkvideo('1B1', 1),
                mkvideo('1B2', 1),
                mkvideo('1B3', 1)
              ],
              [
                mkvideo('1C1', 1),
                mkvideo('1C2', 1),
              ]
            ],
            wants: [
              ['1A1', nil, nil],
              ['1B1', '1B2', '1B3'],
              ['1C1', '1C2', nil],
            ]
          }
        ]
      }

      it 'normalize playlist lengths' do
        tests.each do |attrs|
          tests = attrs[:tests]
          wants = attrs[:wants]
          result = subject.normalize_playlist_lens_base_on_max(tests)
          result = result.inject([]) do |nlist, playlist|
            m = playlist.map { |pl| pl&.id }
            nlist << m
          end
          expect(result).to eq(wants)
        end
      end
    end
  end

  describe '.distribute' do
    include_context 'shared segmenting context' do
      let(:tests) do
        [
          {
            tests: [
              [
                mkvideo('2A1', 2),
                mkvideo('2A2', 2),
                mkvideo('1A3', 1),
                mkvideo('2A1', 2),
                mkvideo('2A2', 2),
                mkvideo('1A3', 1),
                mkvideo('2A1', 2),
                mkvideo('2A2', 2),
                mkvideo('1A3', 1),
                nil, nil, nil, nil, nil
              ],
              [
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                mkvideo('4B1', 4),
                mkvideo('2B2', 2),
                nil, nil, nil, nil, nil, nil
              ],
              [
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('3C2', 3),
                mkvideo('3C3', 3),
                mkvideo('1C1', 1),
                mkvideo('1C1', 1),
              ]
            ],
            wants: [
              '2A1',
              '4B1',
              '1C1',
              '2A2',
              '2B2',
              '3C2',
              '1A3',
              '4B1',
              '3C3',
              '2A1',
              '2B2',
              '1C1',
              '2A2',
              '4B1',
              '3C2',
              '1A3',
              '2B2',
              '3C3',
              '2A1',
              '4B1',
              '1C1',
              '2A2',
              '2B2',
              '3C2',
              '1A3',
              '3C3',
              '1C1',
              '3C2',
              '3C3',
              '1C1',
              '1C1'
            ]
          }
        ]
      end
    end

    it 'distributes evenly the playlists' do
      tests.each do |attrs|
        tests = attrs[:tests]
        wants = attrs[:wants]
        result = subject.distribute(tests)
        expect(result.map(&:id)).to eq(wants)
      end
    end
  end
end
