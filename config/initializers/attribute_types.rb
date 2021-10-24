# frozen_string_literal: true

ActiveRecord::Type.register(:metric_distance, MetricDistanceType)
ActiveModel::Type.register(:metric_distance, MetricDistanceType)
