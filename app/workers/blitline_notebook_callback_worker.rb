class BlitlineNotebookCallbackWorker < BaseWorker
  @queue = :default

  def self.perform(notebook_id, results)
    notebook = Notebook.find(notebook_id)
    Blitline::NotebookCallbackHandler.handle(notebook, JSON(results))
  rescue Resque::TermException
    Raven.capture_message("#{self.to_s} Resque Worker Timeout (#{ENV['RESQUE_TERM_TIMEOUT']}s)", logger: 'timeout')
  end

end
