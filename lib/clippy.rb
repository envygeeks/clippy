require "clippy/version"
require "rbconfig"

if RbConfig::CONFIG["host_os"] !~ /mswin|mingw32/
  require "open3"
else
  require "Win32API"
  require "tempfile"
end

class Object
  def blank?
    (respond_to?(:empty?)) ? empty? : !self
  end
end

class Clippy
  private_class_method :new
  @@encode = true

  [:UnsupportedOS, :UnknownClipboard, :InvalidEncoding].each do |status|
    const_set(status, Class.new(StandardError))
  end

  class << self
    def binary_exist?(bin = nil)
      if bin
        system("which #{bin} > /dev/null 2>&1")
      end
    end

    def encode=(value)
      if [TrueClass, FalseClass].include?(value.class)
        @@encode = value
      end
    end

    def copy(data)
      data = data.to_s unless data.is_a?(String)
      data.gsub!(/\n/, "\r\n")

      if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
        if system("clip /? > NUL")
          begin
            tmpfile = Tempfile.new("clippy")
            tmpfile.write(data)
            tmpfile.flush
            system("clip < #{tmpfile.path}")
          ensure
            tmpfile.close(true)
          end
        else
          raise(UnsupportedOS, "Your Windows version is too old.", "Clippy")
        end
      else
        status = 0
        case true
          when binary_exist?("xsel")
            ["-p", "-b", "-s"].each do |opt|
              Open3.popen3("xsel -i #{opt}") do |stdin, _, _, thread|
                stdin << data
                stdin.close
                status = thread.value
              end
            end

          when binary_exist?("pbcopy")
            Open3.popen3("pbcopy") do |stdin, _, _, thread|
              stdin << data
              stdin.close
              status = thread.value
            end

          when binary_exist?("xclip")
            ["primary", "secondary", "clipboard"].each do |opt|
              Open3.popen3("xclip -i -selection #{opt}") do
              |stdin, _, _, thread|
                stdin << data
                stdin.close
                status = thread.value
              end
            end
        else
          raise(UnknownClipboard, "Clippy requires xsel, xclip or pbcopy.")
        end
      end

      (status != 0) ? (false) : (data)
    end

    def paste(encoding = nil, which = nil)
      which = "clipboard" if encoding.blank? && which.blank?
      if ["clipboard", "primary", "secondary"].include?(encoding)
        which, encoding = encoding, nil
      else
        if encoding && @@encode && defined?(Encoding)
          unless Encoding.list.map(&:to_s).include?(encoding)
            raise InvalidEncoding, "Unsupported encoding selected", "Clippy"
          end
        end
      end

      if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
        Win32API.new("user32", "OpenClipboard", "L", "I").call(0)
          data = Win32API.new("user32", "GetClipboardData", "I", "P").call(1) || ""
        Win32API.new("user32", "CloseClipboard", [], "I").call
      else
        case true
          when binary_exist?("xsel")
            cmd, data = "xsel -o", ""

            case which
              when "clipboard" then cmd+= " -b"
              when "primary" then cmd+= " -p"
              when "secondary" then cmd+= " -s"
            end

            Open3.popen3(cmd) { |_, stdout, _|
              data = stdout.read }

          when binary_exist?("pbpaste")
            data = ""

            Open3.popen3("pbpaste") { |_, stdout, _|
              data = stdout.read || "" }

          when binary_exist?("xclip")
            cmd, data = "xclip -o -selection", ""

            case which
              when "clipboard" then cmd+= " clipboard"
              when "primary" then cmd+= " primary"
              when "secondary" then cmd+= " secondary"
            end

            Open3.popen3(cmd) do |_, stdout, _|
              data = stdout.read || ""
            end
        else
          raise RuntimeError, "Unable to find a supported clipboard", "Clippy"
        end
      end

      if @@encode && defined?(Encoding) && encoding
        if data.encoding.name != Encoding.default_external
          data.encode(encoding)
        end
      end

      (data.blank?) ? (nil) : (data)
    end

    def clear
      if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
        Win32API.new("user32", "OpenClipboard", "L", "I").call(0)
          Win32API.new("user32", "EmptyClipboard", [], "I").call
        Win32API.new("user32", "CloseClipboard", [], "I").call
      else
        if copy("")
          return true
        end
      end

      false
    end
  end
end
