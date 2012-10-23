class Clippy
  module OSX
    def copy(data)
      data = data.to_s unless data.is_a?(String)
      data.gsub!(/\n/, "\r\n")
      status = _copy_and_paste("pbcopy", data)
      (_any_bad_statuses?(status[1])) ? (false) : (status[0])
    end

    def paste(encoding = "UTF-8", which = nil)
      if [:clipboard, :primary, :secondary,
        "clipboard", "primary", "secondary"].include?(encoding)
          which, encoding = encoding, "UTF-8"
      end

      data = _copy_and_paste("pbpaste")
      (_any_bad_statuses?(data[1])) ? (false) : (encode(encoding, data[0]))
    end
  end
end

Clippy.singleton_class.send(:include, Clippy::OSX)
