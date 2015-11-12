require_relative "clippy/version"
require "rbconfig"
require "open3"

if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
  require "Win32API"
end

module Clippy module_function
  @unescape = true
  class << self
    attr_accessor :unescape
  end

  class UnknownClipboardError < StandardError
    def initialize
      super "Unknown clipboard. Clippy requires xclip, xsel or pbcopy"
    end
  end

  def unescape?
    unescape
  end

  COMMAND_ARGS = {
    "xsel" => {
       "stdin".freeze => " -ib",
      "stdout".freeze => " -ob"
    }.freeze,

    "windows" => {
       "stdin".freeze => "".freeze,
      "stdout".freeze => "".freeze
    }.freeze,

    "pbcopy" => {
       "stdin".freeze => "".freeze,
      "stdout".freeze => "".freeze
    }.freeze,

    "xclip" => {
       "stdin".freeze => " -i -selection clipboard",
      "stdout".freeze => " -o -selection clipboard"
    }.freeze
  }.freeze

  def windows?
    RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
  end

  def copy(data)
    data = unescape_newline(data) if unescape?
    data = data.to_s.gsub($/, "\r\n") if $/ != "\r\n"
    run_command("stdin", data)[0] == 0 ? true : false
  end

  def paste
    if windows?
      Win32API.new("user32".freeze, "OpenClipboard", "L", "I").call(0)
        Win32API.new("user32".freeze, "GetClipboardData", "I", "P").call(1) || "".freeze
      Win32API.new("user32".freeze, "CloseClipboard", [], "I").call
    else
      cmd = run_command("stdout".freeze)
      cmd[0] == 0 ? ((cmd[1].nil? || cmd[1].empty?) ? nil : cmd[1]) : false
    end
  end

  def clear
    (copy("".freeze).nil?) ? true : false
  end

  def binary
    @binary ||= if windows?
      "clip".freeze
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
    i, o, e, p = Open3.popen3(binary + COMMAND_ARGS[binary][type])
    type == "stdin" ? i.print(data) : out = o.read.strip

    [i, o, e].each do |m|
      m.close
    end

    [
      p.value,
      type == "stdin" ? data : out
    ]
  end

  def unescape_newline(data)
    data.gsub(/\\n/, "\n").gsub(/\\r/, "\r")
  end
end
