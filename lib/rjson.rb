require 'rjson/parser'
require 'rjson/tokenizer'
require 'stringio'

module RJSON
  VERSION = '1.0.0'

  def self.load(json)
    input   = StringIO.new json
    tok     = RJSON::Tokenizer.new input
    parser  = RJSON::Parser.new tok
    handler = parser.parse
    handler.result
  end
end
