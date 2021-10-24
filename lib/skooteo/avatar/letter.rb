# frozen_string_literal: true

require 'mini_magick'

module Skooteo
  module Avatar
    class Letter
      class << self
        def generate(
          letters: '',
          size: '256x256',
          gravity: 'center',
          pointsize: 110,
          bgcolor: '#d55c3f',
          color: '#ffffff',
          path: Tempfile.new(%w(avatar .jpg)).path
        )
          return if letters.blank?

          MiniMagick::Tool::Convert.new do |image|
            image.size size
            image.gravity gravity
            image.xc bgcolor
            image.pointsize pointsize
            image.fill color
            image.draw "text 0,0 #{letters}"
            image << path
          end

          path
        end
      end
    end
  end
end
