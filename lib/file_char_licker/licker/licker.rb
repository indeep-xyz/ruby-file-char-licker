require "kconv"

module FileCharLicker
  class Licker

    def initialize(file)

      @file = file
    end

    # get lines around for passed file#pos
    #
    # args
    #   pos    ... starting point for file#pos
    #              require to be within contiguous range
    #   needle ... RegExp object for contiguous check
    #
    # returner
    #   String object as lines
    def around_lines(needle)

      file   = @file
      pos    = file.pos
      result = ""

      # scan min
      file.seek(pos)
      min = seek_contiguous_min(needle) || pos

      # scan max
      file.seek(pos)
      max = seek_contiguous_max(needle) || pos

      # read
      # - require succeed scan processes
      if max > min
        file.seek(min)
        result = file.read(max - min).chomp
      end

      result
    end

    # get a backword character from file#pos
    #
    # returner
    #   String object ... exists
    #             nil ... not exists
    def backward_char

      file   = @file
      result = nil

      if file.pos > 0
        file.seek(-1, IO::SEEK_CUR)
        result = file.getc
      end

      result
    end

    # get backward lines from file#pos
    # #pos value should be at SOL (Start Of Line)
    #
    # args
    #   size ... indication of reading bytesize
    #
    # returner
    #   String object as lines
    def backward_lines(size = 10)

      file   = @file
      reg    = Regexp.new('\r\n|\r|\n')
      result = ""

      while file.pos > 0

        char = backward_char

        break if char.nil?

        # backward pos as bytesize of char
        file.seek(-(char.bytesize), IO::SEEK_CUR)

        result.insert(0, char)
        break if char.match(reg) && result.scan(reg).size > size
      end

      result
    end

    # get a line string at current position
    def current_line

      seek_line_head
      @file.gets
    end

    # get forward lines
    #
    # args
    #   size ... number of lines
    #
    # returner
    #   String object as lines
    def forward_lines(size = 10)

      file   = @file
      result = ""

      while result.scan(/\r\n|\r|\n/).size < size && !file.eof?

        result += file.gets
      end

      result
    end

    # scan max file#pos of contiguous.
    # before set to be within contiguous range.
    #
    # args
    #   needle     ... RegExp or String object for contiguous check
    #   step_lines ... number of lines for #forward_lines
    #
    # returner
    #   Integer object for file#pos
    #   EOL of matched line
    def seek_contiguous_max(needle, step_lines = 10)

      file     = @file
      max      = nil

      loop do

        # file#pos before #forward_lines
        pos_old   = file.pos

        lines     = forward_lines(step_lines)
        lines_pos = lines.rindex(needle)

        # for debug
        # p [
        #   lines: lines,
        #   lines_pos: lines_pos,
        #   file_pos: file.pos
        #   ].to_s
        # sleep 0.05

        # if did not match needle
        # - returner is last set value to 'max'
        break if lines_pos.nil?

        lines_end_pos = str_byte_index(lines, /(\r\n|\r|\n)+?/, lines_pos)

        if file.eof?
          max = (lines_end_pos.nil?) ? file.size : pos_old + lines_end_pos
          break
        else
          max = pos_old + lines_end_pos

          break if lines_end_pos < lines.bytesize - 1
        end

      end

      max
    end

    # scan min file#pos of contiguous.
    # before set to be within contiguous range.
    #
    # args
    #   needle     ... RegExp or String object for contiguous check
    #   step_lines ... number of lines for #backward_lines
    #
    # returner
    #   Integer object for file#pos
    #   EOS of matched line
    def seek_contiguous_min(needle, step_lines = 10)

      file = @file
      min  = nil

      loop do

        lines     = backward_lines(step_lines)
        lines_pos = str_byte_index(lines, needle)
        file_pos  = file.pos

        # for debug
        # p [
        #       lines: lines,
        #   lines_pos: lines_pos,
        #    file_pos: file_pos
        #   ].to_s
        # sleep 0.05

        if lines_pos.nil?
          break
        else

          min = file_pos + lines_pos
          break if lines_pos > 0 || file_pos < 1
        end
      end

      min
    end

    def seek_line_head

      file = @file

      if file.pos > 0

        # move pointer to before character
        file.seek(-1, IO::SEEK_CUR)

        # loop
        # - move pointer until reach to EOL of before line.
        until file.getc.match(/[\r\n]/)

          # move pointer to before character
          if file.pos > 1
            file.seek(-2, IO::SEEK_CUR)
          else

            # if EOS, break
            file.rewind
            break
          end
        end
      end

      file.pos
    end

    protected

    # String#index (for method of child class)
    def str_byte_index(haystack, needle, offset = 0)
      haystack.index(needle, offset)
    end
  end
end
