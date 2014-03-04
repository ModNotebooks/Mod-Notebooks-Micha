class SyncWorker < BaseWorker
  @queue = :default

  def self.perform
    User.find_in_batches do |user_batch|
      user_batch.each do |user|
        Syncer.async(:sync, user.id)
      end
    end
  rescue Resque::TermException
    Raven.capture_message("#{self.to_s} Resque Worker Timeout (#{ENV['RESQUE_TERM_TIMEOUT']}s)", logger: 'timeout')
  end
end
