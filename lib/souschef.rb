require_relative "souschef/version"
require_relative "souschef/cli"
require_relative "souschef/apihandler"
require_relative "souschef/dish"
require "net/http"
require "json"

module Souschef
  class Error < StandardError; end
  # Your code goes here...
end
