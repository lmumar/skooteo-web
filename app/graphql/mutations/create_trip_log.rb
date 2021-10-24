# frozen_string_literal: true

module Mutations
  class CreateTripLog < BaseMutation
    argument :input, [Types::TripLogAttributes], required: true

    type Boolean

    def resolve(input:)
      TripLog.transaction {
        input
          .select { |attrs| attrs.trip_info.present? }
          .each(&ReportingServices::TripLogger.method(:save))
      }
      true
    rescue => e
      Rails.logger.error { e.message }
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
