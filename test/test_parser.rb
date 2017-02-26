require 'minitest/autorun'
require 'rjson/parser'
require 'rjson/tokenizer'
require 'rjson/stream_tokenizer'
require 'stringio'

module RJSON
  class TestParser < MiniTest::Unit::TestCase
    def test_array
      parser = new_parser '["foo",null,true]'
      r = parser.parse.result
      assert_equal(['foo', nil, true], r)
    end

    def test_object
      parser = new_parser '{"foo":{"bar":null}}'
      r = parser.parse.result
      assert_equal({ 'foo' => { 'bar' => nil }}, r)
    end

    def test_object_key_without_value_raises_exception
      parser = new_parser '{"foo":}'
      assert_raises(Racc::ParseError) do
        parser.parse.result
      end
    end

    def new_parser string
      tokenizer = Tokenizer.new StringIO.new string
      Parser.new tokenizer
    end
  end
end
