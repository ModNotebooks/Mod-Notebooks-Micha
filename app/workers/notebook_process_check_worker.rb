class NotebookProcessCheckWorker < BaseWorker
  @queue = :default

  def self.perform
    Notebook.uploaded.each do |notebook|
      notebook.async(:process!)
    end
  rescue Resque::TermException
    Raven.capture_message("#{self.to_s} Resque Worker Timeout (#{ENV['RESQUE_TERM_TIMEOUT']}s)", logger: 'timeout')
  end
end
