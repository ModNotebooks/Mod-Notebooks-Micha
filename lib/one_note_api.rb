class OneNoteApi
  attr_reader :access_token

  def initialize(access_token)
    @access_token = access_token
  end

  def add_page(name, file)
    url = URI.parse("#{base_uri}/pages");
    req = Net::HTTP::Post::Multipart.new(url.path,
      Presentation: UploadIO.new(StringIO.new(presentation), "text/html", "Presentation"),
      MyAppPictureId: UploadIO.new(file, "image/jpeg", "MyAppPictureId")
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
    def base_uri
      'https://www.onenote.com/api/v1.0'
    end

    def bearer_token
      "Bearer #{access_token}"
    end

    def presentation
      <<-EOF
      <!DOCTYPE html>
      <html>
       <head>
         <title>Title of the captured OneNote page</title>
         <meta name="created" value="2013-06-11T12:45:00.000-8:00"/>
       </head>
       <body>
          <img src="name:MyAppPictureId" alt="a cool image"/>
       </body>
      </html>
      EOF
    end
end
