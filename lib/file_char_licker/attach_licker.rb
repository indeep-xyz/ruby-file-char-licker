require "file_char_licker/licker/licker"
require "file_char_licker/licker/mb_licker"

module FileCharLicker
  class << self

    def attach(file, encoding = nil)

      seeker = encoding.nil? \
          ? Licker.new(file) \
          : MbLicker.new(file, encoding)

      # attach variables/methods to instance
      file.instance_variable_set(:@file_char_licker, seeker)
      instance_methods_set(file)

      seeker
    end

    private

    def instance_methods_set(file)

      file.instance_eval do
        class << self

          def around_lines(*args)
            @file_char_licker.around_lines(*args)
          end

          def backward_char(*args)
            @file_char_licker.backward_char(*args)
          end

          def backward_lines(*args)
            @file_char_licker.backward_lines(*args)
          end

          def current_line(*args)
            @file_char_licker.current_line(*args)
          end

          def forward_lines(*args)
            @file_char_licker.forward_lines(*args)
          end

          def seek_contiguous_min(*args)
            @file_char_licker.seek_contiguous_min(*args)
          end

          def seek_contiguous_max(*args)
            @file_char_licker.seek_contiguous_max(*args)
          end
          
          def seek_line_head(*args)
            @file_char_licker.seek_line_head(*args)
          end
        end
      end

    end

  end
end
