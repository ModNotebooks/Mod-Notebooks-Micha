module Patterns
  extend ActiveSupport::Concern

  NOTEBOOK_IDENTIFIER_PATTERN = /(\w+)\-(\w+)\-(\w+)/i
end
