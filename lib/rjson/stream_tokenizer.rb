require 'delegate'

module RJSON
  class StreamTokenizer
    class Buffer # :nodoc:
      def initialize io
        @io     = io
        @buffer = []
      end

      def peek len = 1
        (len - @buffer.length).times {
          @buffer << @io.getc
        }
        @buffer.first(len).join
      end

      def getc
        if @buffer.empty?
          @io.getc
        else
          @buffer.shift
        end
      end

      def read len
        len.times.map { getc }.join
      end

      def ungetc c
        @buffer << c
      end
    end

    def initialize io
      @buf = Buffer.new io
    end

    def next_token
      c = @buf.getc
      case c
      when '"'     then [:STRING, scan_string]
      when /[-\d]/
        @buf.ungetc(c)
        [:NUMBER, scan_number]
      when 't'     then [:TRUE, scan_true]
      when 'f'     then [:FALSE, scan_false]
      when 'n'     then [:NULL, scan_null]
      else
        [c, c]
      end
    end

    private

    def scan_null
      "n#{@buf.read(3)}"
    end

    def scan_true
      "t#{@buf.read(3)}"
    end

    def scan_false
      "f#{@buf.read(4)}"
    end

    def scan_number
      str   = ''
      str   << @buf.getc if @buf.peek == '-'
      str   << scan_integral
      str   << scan_decimal if @buf.peek == '.'
      str   << scan_exponent if @buf.peek =~ /[eE]/
      str
    end

    def scan_integral
      return @buf.getc if @buf.peek == '0'

      str = ''
      while @buf.peek =~ /\d/
        str << @buf.getc
      end
      str
    end

    def scan_decimal
      str = @buf.getc

      while @buf.peek =~ /\d/
        str << @buf.getc
      end
      str
    end

    def scan_exponent
      str = @buf.getc

      str << @buf.getc if @buf.peek =~ /[+-]/
      while @buf.peek =~ /\d/
        str << @buf.getc
      end
      str
    end

    def scan_string
      str = ''
      loop do
        c = @buf.getc
        case c
        when /[^"\\]/ then str << c
        when '\\'
          case @buf.peek
          when /["\\\/bfnrt]/
            str << c
            str << @buf.getc
          when 'u'
            str << c
            str << @buf.read(5)
          else
            raise "unknown escape #{c}#{@buf.peek}"
          end
        when '"'
          break
        else
          raise "wtf"
        end
      end

      "\"#{str}\""
    end
  end
end
