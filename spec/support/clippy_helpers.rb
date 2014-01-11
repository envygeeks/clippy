module RSpec
  module Helpers
    module ClippyHelpers
      def stub_binary(with = "xclip")
      clear_binary
        Clippy.send(:instance_variable_set, :@binary, with)
      end

      def clear_binary(var = :binary)
        if Clippy.instance_variable_defined?("@#{var}")
          Clippy.send(:remove_instance_variable, "@#{var}")
        end
      end

      def get_clipboard_contents
      out = ""
        Open3.popen3("xclip -o -selection clipboard") do |i, o, e, p|
          out = o.read.strip
        end
      out
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Helpers::ClippyHelpers
end
