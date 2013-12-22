class NotebookCheckToProcessWorker < BaseWorker
  @queue = :default

  def self.perform
    Notebook.uploaded_notebooks.each do |notebook|
      Notebook.async(:process!, true)
    end
  rescue Resque::TermException
    Raven.capture_message("#{self.to_s} Resque Worker Timeout (#{ENV['RESQUE_TERM_TIMEOUT']}s)", logger: 'timeout')
  end
end
