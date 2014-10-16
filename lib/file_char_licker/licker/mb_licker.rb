# coding: utf-8

require "kconv"

module FileCharLicker
  class MbLicker < FileCharLicker::Licker

    attr_accessor :mb_bytesize_max
    attr_reader   :encoding, :kconv_checker, :nkf_option

    def initialize(file, encoding = 'utf-8')

      super(file)
      init_encoding_variables(encoding)

      @mb_bytesize_max = 6
    end

    # get lines around for passed file#pos
    def around_lines(*args)

      lines = super(*args)
      # p @nkf_option
      # p NKF.nkf('-w', lines)
      # p lines
      NKF.nkf(@nkf_option, lines)
    end

    # get a backword character from file#pos
    #
    # instance variables
    #   mb_bytesize_max ... max bytesize for multibyte character
    #
    # args
    #   update_flag     ... if true, update file#pos for backward character's head
    #
    # returner
    #   String object ... exists
    #             nil ... not exists
    def backward_char

      file    = @file
      pos_max = file.pos - 1
      pos_min = pos_max - @mb_bytesize_max

      pos_max.downto(pos_min) do |pos|

        break if pos < 0

        file.seek(pos)
        char = file.getc

        # return file#getc character
        # - when that is regular for multibyte character
        return char if check_mb(char)
      end

      nil
    end

    def seek_line_head

      file = @file

      # loop
      # - move pointer until reach to EOL of before line.
      while file.pos > 0

        char = backward_char

        # break
        # - if did not get backward character
        # - if got character is a line break character
        break if char.nil? || char.match(/[\r\n]/)

        # backward pos as bytesize of char
        file.seek(-(char.bytesize), IO::SEEK_CUR)
      end

      file.pos
    end

    protected

    # String#index for multibyte
    def str_byte_index(haystack, needle, offset = 0)

      result = nil
      mb_idx = haystack.index(needle, offset)

      unless mb_idx.nil?

        if mb_idx < 1
          result = 0
        else
          matched = haystack.slice(0..mb_idx)
          result  = matched.bytesize - matched[-1].bytesize
        end
      end

      result
    end

    private

    # check multibyte
    def check_mb(char)
      char.__send__(@kconv_checker)
    end

    def init_encoding_variables(enc_source)

      @encoding  = parse_encoding(enc_source)

      case @encoding
      when 'eucjp'
        @kconv_checker = 'iseuc'
        @nkf_option    = '-exm0'

      when 'jis'
        @kconv_checker = 'isjis'
        @nkf_option    = '-jxm0'

      when 'sjis'
        @kconv_checker = 'issjis'
        @nkf_option    = '-sxm0'

      when 'utf8'
        @kconv_checker = 'isutf8'
        @nkf_option    = '-wxm0'
      end
    end

    def parse_encoding(enc)

      result = nil

      unless enc.nil?
        case
        when enc.match(/^e/)     then result = 'eucjp'
        when enc.match(/^j/)     then result = 'jis'
        when enc.match(/^s/)     then result = 'sjis'
        when enc.match(/^u.*8?/) then result = 'utf8'
        end
      end

      result
    end
  end
end
