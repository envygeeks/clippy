module RSpec
  module Helpers
    module ClippyHelpers

      # --
      # Stub the binary to trick.
      # --
      def stub_binary(with = "xclip")
        clear_binary
        Clippy.send(
          :instance_variable_set, :@binary, with
        )
      end

      # --
      # Clear the binary.
      # --
      def clear_binary(var = :binary)
        if Clippy.instance_variable_defined?("@#{var}")
          then Clippy.send(
            :remove_instance_variable, "@#{var}"
          )
        end
      end

      # --
      # Pull the contents from the clipboard.
      # --
      def get_clipboard_contents
        out = ""

        Open3.popen3("xclip -o -selection clipboard") do |_, o, _, _|
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
