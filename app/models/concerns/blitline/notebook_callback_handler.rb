class Blitline::NotebookCallbackHandler

  ProcessingError = Class.new(ModError)

  class << self
    def handle(notebook, data)
      instance = new(notebook.id)
      instance.handle(data)
    end
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def initialize(notebook_id)
    @notebook_id = notebook_id
  end

  def handle(data)
    populate_pages(data)
    notebook.available!
  rescue ProcessingError => e
    notebook.process_failed!
    Raven.capture_message("Blitline Error Processing PDF", {
      extra: data
    })
  end

  def populate_pages(data)
    images = data['images']['image_results'].uniq { |img| img['image_identifier'] }

    # Delete pages that already exsist that are higher then the page number
    # of the current PDF
    notebook.pages.where('index > ?', images.count).map(&:destroy!)

    images.collect do |image|
      if image['error'].present?
        raise ProcessingError
      end

      next unless image['image_identifier'][Patterns::NOTEBOOK_DIGEST] == notebook.digest

      filename = notebook.s3_versioned_url_to_filename(image['url'])
      page_number = notebook.image_identifier_to_page(image['image_identifier'])

      page = notebook.pages.find_or_create_by!(index: page_number)
      page.update_column('image', filename)
      page
    end
  end

  def notebook
    @notebook ||= Notebook.find(@notebook_id)
  end
end
