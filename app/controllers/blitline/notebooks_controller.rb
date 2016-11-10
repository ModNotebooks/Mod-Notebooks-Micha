class Blitline::NotebooksController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def blitline
    p "*" * 100
    p "notebooks_controller"
    p params[:results]
    Resque.enqueue(BlitlineNotebookCallbackWorker, params[:id], params[:results])
    head :ok
  end

end
