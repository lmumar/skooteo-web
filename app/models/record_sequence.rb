# frozen_string_literal: true

class RecordSequence < ApplicationRecord
  def self.next(record)
    connection.execute <<-SQL.strip_heredoc
      INSERT INTO record_sequences (record_id, record_type, seq)
      VALUES(#{record.id}, '#{record.class.name}', 1)
      ON CONFLICT (record_id, record_type)
      DO
        UPDATE SET seq = record_sequences.seq + 1
      RETURNING seq
      ;
    SQL
  end
end
