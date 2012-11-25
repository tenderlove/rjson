require 'minitest/autorun'
require 'rjson/tokenizer'
require 'stringio'

module RJSON
  class TestTokenizer < MiniTest::Unit::TestCase
    [
      [:NUMBER, "0.1234"],
      [:NUMBER, "0"],
      [:NUMBER, "-0"],
      [:NUMBER, "-1234.432"],
      [:NUMBER, "1234.432"],
      [:NUMBER, "1234"],
      [:NUMBER, "1234e1"],
      [:NUMBER, "1234e-1"],
      [:NUMBER, "1234e+1"],
      [:NUMBER, "1234e+12"],

      [:STRING, '"hello"'],
      [:STRING, '"h\"ello"'],
      [:STRING, '"h\nello"'],
      [:STRING, '"h\u1234ello"'],
      [:STRING, '"h\/ello"'],

      [:TRUE, 'true'],
      [:FALSE, 'false'],
      [:NULL, 'null'],
      ['{', '{'],
      [':', ':'],
    ].each do |token|
      define_method("test_#{token.join '_'}") do
        tok = new_tokenizer token.last
        assert_equal token, tok.next_token
      end
    end

    def new_tokenizer string
      Tokenizer.new StringIO.new string
    end
  end
end
