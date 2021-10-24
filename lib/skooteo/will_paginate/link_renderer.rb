# frozen_string_literal: true

require "will_paginate/view_helpers/action_view"

module Skooteo
  module WillPaginate
    class LinkRenderer < ::WillPaginate::ActionView::LinkRenderer
      def link(text, target, attributes = {})
        if @options.dig(:params, :remote)
          attributes['data-remote'] = true
        end
        attributes[:class] = [attributes[:class], 'button is-rounded'].compact.join(' ')
        super
      end
    end
  end
end
