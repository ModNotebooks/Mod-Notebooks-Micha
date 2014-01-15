class PageFiller

  attr_reader :notebook

  def initialize(notebook)
    unless notebook.pdf?
      raise ArgumentError, 'Notebook does not have a PDF'
    end

    @notebook = notebook
  end

  def uri
    notebook.pdf.url
  end

  def tmp_dir
    "#{Rails.root}/tmp/notebooks"
  end

  def pdf
    @pdf ||= Grim.reap(file.path)
  end

  def fill_pages(refill=false)
    pages = []

    FileUtils.mkdir_p(tmp_dir)

    # Delete pages that already exsist that are higher then the page number
    # of the current PDF
    notebook.pages.where('index > ?', pdf.count).map(&:destroy!)

    pdf.each do |page|
      index = page.number - 1
      page_model = notebook.pages.find_or_create_by(index: index)
      filepath = "#{tmp_dir}/#{notebook.id}-p#{index}.png"

      pages << page_model

      begin
        if (!page_model.image? || refill) && page.save(filepath)
          page_model.image.store!(File.open(filepath))
          File.delete(filepath)
        end
      rescue
        next
      end
    end

    yield pages
  end

  private
    def file
      if @file.blank?
        @file = Kernel.open(uri)
        @file = @file.is_a?(String) ? StringIO.new(@file) : @file
      end
      @file
    end

end
