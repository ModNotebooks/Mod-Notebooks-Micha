class Blitline::NotebooksController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def blitline
    Resque.enqueue(BlitlineNotebookCallbackWorker, params[:id], params[:results])
    head :ok
  end

end
