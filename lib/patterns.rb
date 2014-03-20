module Patterns
  extend ActiveSupport::Concern

  NOTEBOOK_IDENTIFIER_PATTERN = /(\w+)\-(\w+)\-(\w+)/i
  BITLINE_PDF_PAGE = /(?:__)(\d+)/i
  BITLINE_FILE_WITHOUT_VERSION = /([a-zA-Z0-9]+__\d+\.\w{3,})/i
  NOTEBOOK_DIGEST = /\A([a-zA-Z0-9]+)/i
end
