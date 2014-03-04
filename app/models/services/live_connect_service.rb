# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  user_id         :integer
#  provider        :string(255)
#  uid             :string(255)
#  name            :string(255)
#  email           :string(255)
#  nickname        :string(255)
#  token           :text
#  secret          :text
#  refresh_token   :text
#  expires_at      :datetime
#  checked_at      :datetime
#  deleted_at      :datetime
#  delta_cursor    :text
#  meta            :hstore
#  disabled_at     :datetime
#  disabled_reason :string(255)
#  disabled_data   :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

class LiveConnectService < Service

  def with_api(options = {},  &block)
    options.reverse_merge!(on_rescue: [])
    super
  rescue JSON::ParserError => e
    # Raven.capture_exception(e, extra: { service_id: self.id })
    return options[:on_rescue]
  rescue Service::InvalidRequest => e
    if e.message.match(/(credentials not recognized|access is denied)/)
      #error!(:not_authorized)
    else
      # Raven.capture_exception(e, extra: {service_id: self.id})
    end
    return options[:on_rescue]
  end

  def create_api
    OneNoteApi.new(self.token)
  end

  def syncer(notebook)
    LiveConnectSyncer.new(self, notebook)
  end

  def refresh_access_token!
    response = HTTParty.post(
      'https://login.live.com/oauth20_token.srf',
      body: {
        refresh_token: self.refresh_token,
        client_id:     ENV['LIVECONNECT_KEY'],
        client_secret: ENV['LIVECONNECT_SECRET'],
        grant_type:    'refresh_token'
      },
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Accept'       => 'application/json'
      }
    )

    if response.code != 200
      body = JSON.load(response.body)

      if response.code.between?(400, 499)
        error!(:not_authorized)
      end

      return false
    end

    credentials = JSON.load(response.body)

    self.token         = credentials['access_token']
    self.refresh_token = credentials['refresh_token']
    self.expires_at    = Time.now.utc.advance(seconds: credentials['expires_in'].to_i)
    self.save!
  end

  class OneNoteApi
    URL = 'https://www.onenote.com/api/v1.0'

    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def add_page(page)
      presentation = page_presentation(page)
      file         = page_file(page)
      p_id         = page_id(page)

      url = URI.parse("#{URL}/pages")

      req = Net::HTTP::Post::Multipart.new url.path,
        Presentation: UploadIO.new(StringIO.new(presentation), "text/html", "Presentation"),
        :"#{p_id}" => UploadIO.new(file, "image/jpeg", p_id)

      request(url, req)
    end

    def request(url, req)
      net = Net::HTTP.new(url.host, url.port)
      net.use_ssl = true

      response = net.start do |http|
        req['Authorization'] = bearer_token
        http.request(req)
      end

      raise Service::InvalidRequest.new(build_error_message(response)) unless [200, 201].include?(response.code.to_i)

      JSON.load(response.body)
    end

    private
      def build_error_message(response)
        "Status: %d.\n\nServer message:\n%s" % [response.code, response.body]
      end

      def page_file(page)
        Kernel.open(page.image.url(:large))
      end

      def page_title(page)
        notebook = page.notebook
        "Mod Notebook (#{notebook.name || "Untitled"}) - Page ##{page.index}"
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

end
