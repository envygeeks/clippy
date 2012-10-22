class Clippy
  module Linux
    def copy(data)
      data = data.to_s unless data.is_a?(String)
      data.gsub!(/\n/, "\r\n")
      out = ""
      case true
      when binary_exist?("xsel")
        ["-p", "-b", "-s"].each do |opt|
          out = _copy_and_paste("xsel -i #{opt}", data)
        end
      when binary_exist?("xclip")
        ["primary", "secondary", "clipboard"].each do |opt|
          out = _copy_and_paste("xclip -i -selection #{opt}", data)
        end
      else
        raise UnknownClipboard, "Clippy requires xsel or xclip."
      end

      (_any_bad_statuses?(out[1])) ? (false) : (out[0])
    end

    def paste(encoding = "UTF-8", which = nil)
      if [:clipboard, :primary, :secondary,
        "clipboard", "primary", "secondary"].include?(encoding)
          which, encoding = encoding, "UTF-8"
      end

      case true
      when binary_exist?("xsel")
        cmd = "xsel -o"

        case which
          when "clipboard" then cmd+= " -b"
          when "primary" then cmd+= " -p"
          when "secondary" then cmd+= " -s"
        end

        data = _copy_and_paste(cmd)
      when binary_exist?("xclip")
        cmd = "xclip -o -selection"

        case which
          when "clipboard" then cmd+= " clipboard"
          when "primary" then cmd+= " primary"
          when "secondary" then cmd+= " secondary"
        end

        data = _copy_and_paste(cmd)
      else
        raise RuntimeError, "No system clipboard found."
      end

      (_any_bad_statuses?(data[1])) ? (false) : (encode(encoding, data[0]))
    end
  end
end

Clippy.singleton_class.send(:include, Clippy::Linux)
