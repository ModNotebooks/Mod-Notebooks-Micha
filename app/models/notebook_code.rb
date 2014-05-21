class NotebookCode

  attr_reader :code

  PAPER_TYPES = { "01" => "plain", "02" => "lined", "03" => "dotgrid" }

  def initialize(code)
    @code = code
  end

  def valid?
    valid_format? && valid_color_code? && valid_paper_code?
  end

  def notebook_settings
    @notebook_settings ||= NotebookSetting.find_by("lower(color_code) = ?", color_code)
  end

  def color
    notebook_settings.try(:color)
  end

  def cover_image
    notebook_settings.try(:cover_image)
  end

  def paper
    PAPER_TYPES[code_parts[:paper]]
  end

  def paper_code
    code_parts[:paper]
  end

  def color_code
    code_parts[:color].downcase
  end

  def identifier
    code_parts[:identifier]
  end

  private

    def valid_format?
      !!(@code.match(Patterns::NOTEBOOK_IDENTIFIER_PATTERN))
    end

    def valid_color_code?
      !!notebook_settings
    end

    def valid_paper_code?
      PAPER_TYPES.keys.include? paper_code
    end

    def code_parts
      parts = code.split('-')
      parts.count == 3 ? { color: parts[0], paper: parts[1], identifier: parts[2] } : {}
    end
end
