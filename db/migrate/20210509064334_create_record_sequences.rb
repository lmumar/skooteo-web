# frozen_string_literal: true

class CreateRecordSequences < ActiveRecord::Migration[6.1]
  def change
    create_table :record_sequences do |t|
      t.string :record_type, null: false
      t.integer :record_id, null: false
      t.integer :seq, default: 0
      t.index [ :record_type, :record_id ], unique: true
    end
  end
end
