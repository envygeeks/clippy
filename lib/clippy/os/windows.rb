class Clippy
  class << self
    def copy(data)
      if system("clip /? > NUL")
        begin
          tmpfile = Tempfile.new("clippy")
          tmpfile.write(data)
          tmpfile.flush
          system("clip < #{tmpfile.path}")

          (_any_bad_statuses?($?)) ? (false) : (data)
        ensure
          tmpfile.close(true)
        end
      else
        # Probably on that shit called Windows xp, mabye yeah!?
        raise UnsupportedOS, "Your Windows version is too old."
      end
    end

    def paste(encoding = "UTF-8", which = nil)
      if [:clipboard, :primary, :secondary,
        "clipboard", "primary", "secondary"].include?(encoding)
          which, encoding = encoding, "UTF-8"
      end

      Win32API.new("user32", "OpenClipboard", "L", "I").call(0)
        data = Win32API.new("user32", "GetClipboardData", "I", "P").call(1) || ""
      Win32API.new("user32", "CloseClipboard", [], "I").call

      encode(encoding, (data ? data : ""))
    end

    def clear
      Win32API.new("user32", "OpenClipboard", "L", "I").call(0)
        Win32API.new("user32", "EmptyClipboard", [], "I").call
      Win32API.new("user32", "CloseClipboard", [], "I").call
    end
  end
end
