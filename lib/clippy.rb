require_relative "clippy/version"
require "rbconfig"
require "open3"

if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
  require "Win32API"
end

module Clippy module_function
  class UnknownClipboardError < StandardError
    def initialize
      super "Unknown clipboard. Clippy requires xclip, xsel or pbcopy"
    end
  end

  CommandArgs = {
    "windows" => "",
    "xsel"=> {
      "stdin" => " -ib",
      "stdout" => " -ob"
    },
    "pbcopy"=> {
      "stdin"=> "",
      "stdout"=> ""
    },
    "xclip"=> {
      "stdin" => " -i -selection clipboard",
      "stdout" => " -o -selection clipboard"
    }
  }

  def windows?
    RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
  end

  def copy(data)
    run_command("stdin", $/ != "\r\n" ? data.to_s.gsub($/, "\r\n") : data)[0] == 0 ? true : false
  end

  def paste
    if windows?
      Win32API.new("user32", "OpenClipboard", "L", "I").call(0)
        data = Win32API.new("user32", "GetClipboardData", "I", "P").call(1) || ""
      Win32API.new("user32", "CloseClipboard", [], "I").call
    else
      cmd = run_command("stdout")
      cmd[0] == 0 ? ((cmd[1].nil? || cmd[1].empty?) ? nil : cmd[1]) : false
    end
  end

  def clear
    (copy("").nil?) ? true : false
  end

  def binary
    @binary ||= if windows?
      "clip"
    else
      case true
        when system("which xclip > /dev/null 2>&1") then "xclip"
        when system("which xsel > /dev/null 2>&1") then "xsel"
        when system("which pbcopy > /dev/null 2>&1") then "pbcopy"
      else
        raise UnknownClipboardError
      end
    end
  end

  def run_command(type, data = "")
    stdin, stdout, stderr, pid = Open3.popen3(binary + CommandArgs[binary][type])
    type == "stdin" ? stdin.puts(data) : out = stdout.read.strip
    [stdin, stdout, stderr].each { |m| m.close }
    [pid.value, type == "stdin" ? data : out]
  end
end
