require "rbconfig"

if RbConfig::CONFIG["host_os"] !~ /mswin|mingw32/
  require "open3"
else
  require "Win32API"
  require "tempfile"
end

class Object
  ##
  # ---
  # Hood jacked from Rails.
  ##

  def blank?
    (respond_to?(:empty?)) ? (empty?) : (!self)
  end
end

class Clippy
  private_class_method :new
  @@encode = true

  [:UnsupportedOS, :UnknownClipboard, :InvalidEncoding].each do |status|
    const_set(status, Class.new(StandardError))
  end

  class << self
    VERSION = "1.0.0"
    def version
      VERSION
    end

    ##
    # ---
    # Doesn't work on Windows.
    ##

    def binary_exist?(bin = nil)
      if bin
        system("which #{bin} > /dev/null 2>&1")
      end
    end

    def encode=(value)
      if [TrueClass, FalseClass].include?(value.class)
        @@encode = value
      end

      @@encode
    end

    def copy(data)
      ##
      # ---
      # Always convert to a string and convert \n to \r\n because shit like
      # Pidgin, Empathy, aMSN and other fucking clients have no idea what the
      # hell \n is for, that or they just ignore it like jackasses, jackasses.

      data = data.to_s unless data.is_a?(String)
      data.gsub!(/\n/, "\r\n")

      if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
        if system("clip /? > NUL")
          begin
            tmpfile = Tempfile.new("clippy")
            tmpfile.write(data)
            tmpfile.flush
            system("clip < #{tmpfile.path}")

            ##
            # Assume by default that it succeed and just validate if it did
            # leave our system with an improper exit status, Windows does
            # exit with 0 by default right yeah?

            status = [0]
            if $? != 0
              status = [$?]
            end
          ensure
            tmpfile.close(true)
          end
        else
          raise UnsupportedOS, "Your Windows version is too old."
        end
      else
        status = []

        case true
          ##
          # ---
          # xsel is a Linux utility.
          # apt-get install xsel.

          when binary_exist?("xsel")
            ["-p", "-b", "-s"].each do |opt|
              out = _copy_and_paste("xsel -i #{opt}", data)
              status.push(out[1])
            end

          ##
          # ---
          # pbpaste is for Mac's though it could change.
          # I don't know if it has multiple-boards.
          ##

          when binary_exist?("pbcopy")
            out = _copy_and_paste("pbcopy", data)
            status.push(out[1])

          ##
          # ---
          # xclip is a Linux utitily.
          # apt-get install xclip.
          ##

          when binary_exist?("xclip")
            ["primary", "secondary", "clipboard"].each do |opt|
              out = _copy_and_paste("xclip -i -selection #{opt}", data)
              status.push(out[1])
            end
        else
          raise UnknownClipboard, "Clippy requires xsel, xclip or pbcopy."
        end
      end

      (_any_bad_statuses?(status)) ? (false) : (data)
    end

    def paste(encoding = nil, which = nil)
      which = "clipboard" if encoding.blank? && which.blank?
      if ["clipboard", "primary", "secondary"].include?(encoding)
        which, encoding = encoding, nil
      else
        if encoding && @@encode && defined?(Encoding)
          unless Encoding.list.map(&:to_s).include?(encoding)
            raise InvalidEncoding, "Unsupported encoding selected"
          end
        end
      end

      if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
        Win32API.new("user32", "OpenClipboard", "L", "I").call(0)
          data = Win32API.new("user32", "GetClipboardData", "I", "P").call(1) || ""
        Win32API.new("user32", "CloseClipboard", [], "I").call
      else
        case true
          ##
          # ---
          # xsel is a Linux utility.
          # apt-get install xsel.

          when binary_exist?("xsel")
            cmd = "xsel -o"

            case which
              when "clipboard" then cmd+= " -b"
              when "primary" then cmd+= " -p"
              when "secondary" then cmd+= " -s"
            end

            data = _copy_and_paste(cmd)

          ##
          # ---
          # pbpaste is for Mac's though it could change.
          # I don't know if it has multiple-boards.
          ##

          when binary_exist?("pbpaste")
            data = _copy_and_paste("pbpaste")

          ##
          # ---
          # xclip is a Linux utitily.
          # apt-get install xclip.
          ##

          when binary_exist?("xclip")
            cmd = "xclip -o -selection"

            case which
              when "clipboard" then cmd+= " clipboard"
              when "primary" then cmd+= " primary"
              when "secondary" then cmd+= " secondary"
            end

            data = _copy_and_paste(cmd)
        else
          raise RuntimeError, "Unable to find a supported clipboard"
        end
      end

      if @@encode && defined?(Encoding) && encoding
        if data[0].encoding.name != Encoding.default_external
          data[0] = data[0].encode(encoding)
        end
      end

      (_any_bad_statuses?(data[1])) ? (false) : (data[0])
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
    end

    protected
    def _copy_and_paste(binary, data = nil)
      status = 1

      Open3.popen3(binary) do |stdin, stdout, _, thread|
        if !data.nil?
          stdin << data
          stdin.close
          status = thread.value
        else
          data = stdout.read || ""
          stdout.close
          status = thread.value
        end
      end

      [data, status]
    end

    ##
    # Takes a set of statuses from a looped execute and makes sure that they all
    # returned 0 and if a single one did not return 0 then it considers them all
    # failed, because with Linux a missed clipboard could be the one that you
    # actually needed.
    ##

    protected
    def _any_bad_statuses?(statuses)
      if !statuses.is_a?(Array)
        return (statuses != 0) ? (true) : (false)
      else
        bad_status = false
        statuses.each do |status|
          if (status.is_a?(Process::Status) && status.success?) || status == 0
            bad_status = true
          end
        end
      end

      bad_status ? (false) : (true)
    end
  end
end
