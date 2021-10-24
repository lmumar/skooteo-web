# frozen_string_literal: true

class AddDefaultToRoutesTableDistanceField < ActiveRecord::Migration[6.1]
  def change
    change_column_default :routes, :distance, from: nil, to: 0
  end
end
