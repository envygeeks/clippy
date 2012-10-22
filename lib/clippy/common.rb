class Clippy
  class << self
    ##
    # Doesn't work on Windows.
    ##

    def binary_exist?(bin = nil)
      if bin
        system("which #{bin} > /dev/null 2>&1")
      end
    end

    ##
    # Enables or disables encoding in Clippy.
    ##

    def encode=(value)
      if [TrueClass, FalseClass].include?(value.class)
        @@encode = value
      end

      @@encode
    end

    ##
    # Does the encoding for Clippy.
    ##

    def encode(encoding, data)
      if @@encode && defined?(Encoding)
        if Encoding.list.map(&:to_s).include?(encoding)
          data = data.encode(encoding)
        else
          raise InvalidEncoding, "#{encoding} is not supported."
        end
      end

      data
    end

    ##
    # A deduplication method to DRY up code that peforms the actual command.
    ##

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
          if (status.is_a?(Process::Status) && !status.success?) || status == 0
            bad_status = true
          end
        end
      end

      bad_status ? (false) : (true)
    end
  end
end
