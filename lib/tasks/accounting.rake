# frozen_string_literal: true

namespace :accounting do
  desc 'refund unplayed videos'
  task process_refunds: :environment do
    timezone  = ENV.fetch('SKOOTEO_TIME_ZONE') { 'Asia/Manila' }
    Time.zone = timezone
    RefundServices.process_refunds
    puts 'done.'
  end
end
