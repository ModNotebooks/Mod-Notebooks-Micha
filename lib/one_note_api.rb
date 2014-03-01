class OneNoteApi
  include HTTMultiParty

  base_uri 'https://www.onenote.com/api/v1.0'

  attr_reader :access_token

  def initialize(access_token)
    @access_token = access_token
    self.class.headers "Authorization" => bearer_token
  end

  def add_page(name, file)
    self.class.post('/pages', query: {
      name: name,
      'Presentation' => '',
      image: file
    }, detect_mime_type: true)
  end

  private
    def bearer_token
      "Bearer #{access_token}"
    end
end
