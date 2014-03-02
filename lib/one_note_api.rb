class OneNoteApi
  attr_reader :access_token

  def initialize(access_token)
    @access_token = access_token
  end

  def add_page(name, page)
    presentation = page_presentation(page)
    file         = page_file(page)
    p_id         = page_id(page)

    url = URI.parse("#{base_uri}/pages")

    req = Net::HTTP::Post::Multipart.new(url.path,
      Presentation: UploadIO.new(StringIO.new(presentation), "text/html", "Presentation"),
      :"#{p_id}" => UploadIO.new(file, "image/jpeg", p_id)
    );
    request(url, req)
  end

  def request(url, req)
    net = Net::HTTP.new(url.host, url.port)
    net.use_ssl = true

    net.start do |http|
      req['Authorization'] = bearer_token
      http.request(req)
    end
  end

  private
    def page_file(page)
      @page_file ||= Kernel.open(page.image.url(:large))
    end

    def page_title(page)
      notebook = page.notebook
      "Mod Notebook (#{notebook.name || "Untitled"}) - Page ##{page.index}"
    end

    def base_uri
      'https://www.onenote.com/api/v1.0'
    end

    def bearer_token
      "Bearer #{access_token}"
    end

    def page_id(page)
      "PageImage#{page.id}"
    end

    def page_presentation(page)
      <<-EOF
        <!DOCTYPE html>
        <html>
          <head>
            <title>#{page_title(page)}</title>
            <meta name="created" value="#{DateTime.now.to_s}"/>
          </head>
          <body>
            <img src="name:#{page_id(page)}" alt="#{page_title(page)}"/>
          </body>
        </html>
      EOF
    end
end
