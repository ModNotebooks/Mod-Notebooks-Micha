class Blitline::NotebookPDF

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  class << self
    def process(notebook, async: true)
      if notebook.pdf.present?
        instance = new(notebook.id)
        instance.process_with_blitline(async: async)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def initialize(notebook_id)
    @notebook_id = notebook_id
  end

  def process_with_blitline(async: true)
    url = notebook.pdf.url
    process_url_with_blitline(url, async: async)
  rescue Timeout::Error => e
    # TODO: Record this
  end

  def process_url_with_blitline(url, options={}, async: true)
    options.reverse_merge!(
      application_id: ENV['BLITLINE_APPLICATION_ID'],
      wait_for_s3: true,
      long_running: true,
      v: '1.18',
      src: url,
      src_type: 'burst_pdf',
      src_data: { dpi: 300 },
      postback_url: postback_url,
      functions: [
        blitline_version(:thumb,  { width: '200'  }),
        blitline_version(:small,  { width: '400'  }),
        blitline_version(:medium, { width: '800'  }),
        blitline_version(:large,  { width: '1600' }),
        blitline_version(:xlarge, { width: '3200' }),
      ]
    )

    blitline = Blitline.new
    blitline.add_job_via_hash(options)
    async ? blitline.post_jobs : blitline.post_job_and_wait_for_poll
  end

  def blitline_version(version, params = {})
    digest = notebook.digest

    {
      name: 'resize_to_fit',
      params: params,
      save: {
        image_identifier: digest,
        exstension: '.jpg',
        s3_destination: {
          bucket: PageUploader.fog_directory,
          key: "#{PageUploader::STORE_DIR}/#{version}_#{digest}.jpg",
          headers: { "x-amz-grant-read" => nil }
        },
        quality: 80
      }
    }
  end

  def postback_url
    return "http://requestb.in/xs1zoqxs" if Rails.env.development?

    helper = Rails.application.routes.url_helpers
    host   = ActionMailer::Base.default_url_options[:host]
    domain = "callback.#{host}"

    protocol = Rails.configuration.force_ssl ? 'https' : 'http'
    helper.notebook_processed_url(notebook.id, host: domain, protocol: protocol)
  end

  def notebook
    @notebook ||= Notebook.find(@notebook_id)
  end
end
