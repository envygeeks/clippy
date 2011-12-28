require 'rbconfig'
require 'open3'

if RbConfig::CONFIG['host_os'] =~ /mswin/
  require 'Win32API'
  require 'tempfile'
end

class Clippy
  private_class_method :new

  [:UnsupportedOS, :UnknownClipboard, :InvalidEncoding].each do |status|
    const_set(status, Class.new(StandardError))
  end

  class << self

    ##
    # Version.
    def version
      '0.1.3'
    end

    def binary_exist?(bin)
      system("which #{bin} > /dev/null 2>&1")
    end

    ##
    # Copy
    def copy(data)
      ##
      # For shit like Pidgin..
      data.gsub!(/\n/, "\r\n")
      if RbConfig::CONFIG['host_os'] =~ /mswin/
        if system('clip /? 2>&1 1>&0')
          begin
            tmpfile = Tempfile.new('clippy')
            tmpfile.write(data)
            tmpfile.flush
            system("clip < #{tmpfile.path}")
          ensure
            tmpfile.close(true)
          end
        else
          raise(UnsupportedOS, 'Your Windows version is too old.')
        end
      else
        case true
        when binary_exist?('xsel')
          ['-p', '-b', '-s'].each do |opt|
            Open3.popen3("xsel -i #{opt}") do |stdin|
              stdin << data
            end
          end
        when binary_exist?('pbcopy')
          Open3.popen3('pbcopy') do |stdin|
            stdin << data
          end
        when binary_exist?('xclip')
          ['primary', 'secondary', 'clipboard'].each do |opt|
            Open3.popen3("xclip -i -selection #{opt}") do |stdin|
              stdin << data
            end
          end
        else
          raise(UnknownClipboard, 'Could not find a clipboard util.')
        end
      end

      ((data.nil? or data.empty?)?(false):(data))
    end

    ##
    # Paste
    def paste(encoding = nil, which = nil)
      if defined? Encoding and encoding
        unless Encoding.list.map(&:to_s).include?(encoding)
          raise(InvalidEncoding, 'The encoding you selected is unsupported')
        end
      end

      if RbConfig::CONFIG['host_os'] =~ /mswin/
        Win32API.new('user32', 'OpenClipboard', 'L', 'I').call(0)
          data = Win32API.new('user32', 'GetClipboardData', 'I', 'P').call(1) || ''
        Win32API.new('user32', 'CloseClipboard', [], 'I').call
      else
        case true
        when binary_exist?('xsel')
          cmd = 'xsel -o'

          case which
            when 'clipboard' then cmd+= ' -b'
            when 'primary' then cmd+= ' -p'
            when 'secondary' then cmd+= ' -s'
          end

          Open3.popen3(cmd) do |_, stdout|
            data = stdout.read
          end
        when binary_exist?('pbpaste')
          Open3.popen('pbpaste') do |_, stdout|
            data = stdout.read || ''
          end
        when binary_exist?('xclip')
          cmd = 'xclip -o'

          case which
            when 'clipboard' then cmd+= ' clipboard'
            when 'primary' then cmd+= ' primary'
            when 'secondary' then cmd+= ' secondary'
          end

          Open3.popen3(cmd) do |_, stdout|
            data = stdout.read || ''
          end
        end
      end

      if defined? Encoding
        if data.encoding.name != Encoding.default_external
          data.encode(encoding ? encoding : Encoding.default_external)
        end
      end

      ((data.nil? or data.empty?)?(false):(data))
    end

    def clear
      if RbConfig::CONFIG['host_os'] =~ /mswin/
        Win32API.new('user32', 'OpenClipboard', 'L', 'I').call(0)
          Win32API.new('user32', 'EmptyClipboard', [], 'I').call
        Win32API.new('user32', 'CloseClipboard', [], 'I').call
      else
        if copy('')
          return true
        end
      end

      false
    end
  end
end
