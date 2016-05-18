
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

require "English"
require_relative "clippy/version"
require "rbconfig"
require "open3"

if RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
  require "Win32API"
end

module Clippy
  @unescape = true
  module_function

  # --

  class << self
    attr_accessor :unescape
  end

  # --

  class UnknownClipboardError < StandardError
    def initialize
      super "Unknown clipboard. Clippy requires xclip, xsel or pbcopy"
    end
  end

  # --

  def unescape?
    unescape
  end

  # --

  COMMAND_ARGS = {
    "xsel" => {
      "stdin"  => " -ib",
      "stdout" => " -ob"
    },

    "windows" => {
      "stdin"  => "",
      "stdout" => ""
    },

    "pbcopy" => {
      "stdin"  => "",
      "stdout" => ""
    },

    "xclip" => {
      "stdin"  => " -i -selection clipboard",
      "stdout" => " -o -selection clipboard"
    }
  }.freeze

  # --
  # Whether or not this is Windows.
  # @return [Fixnum,nil]
  # --
  def windows?
    RbConfig::CONFIG["host_os"] =~ /mswin|mingw32/
  end

  # --
  # @return [true,false]
  # Copy.
  # --
  def copy(data)
    data = unescape_newline(data) if unescape?
    out  = run_command("stdin", data)
    out [0] == 0 ? true : false
  end

  # --
  # @return [true,false]
  # Paste
  # --
  def paste
    if windows?
      Win32API.new("user32".freeze, "OpenClipboard", "L", "I").call(0)
      Win32API.new("user32".freeze, "GetClipboardData", "I", "P").call(1) || ""
      Win32API.new("user32".freeze, "CloseClipboard", [], "I").call
    else
      cmd = run_command("stdout".freeze)
      cmd[0] != 0 ? false : \
        if cmd[1].nil? || cmd[1].empty?
          then nil else cmd[1]
        end
    end
  end

  # --
  # @return [true,false]
  # Clear.
  # --
  def clear
    copy("".freeze).nil?? true : false
  end

  # --
  # Pull out the binary we need to use.
  # rubocop:disable Lint/LiteralInCondition
  # @return [String]
  # --
  def binary
    @binary ||= begin
      if windows?
        "clip".freeze
      else
        case true
        when system("which xclip > /dev/null 2>&1")  then "xclip"
        when system("which xsel > /dev/null 2>&1")   then "xsel"
        when system("which pbcopy > /dev/null 2>&1") then "pbcopy"
        else
          raise UnknownClipboardError
        end
      end
    end
  end

  # --
  # Run a command and get the output.
  # rubocop:enable Lint/LiteralInCondition
  # @return [Array]
  # --
  def run_command(type, data = "")
    i, o, e, p = Open3.popen3(binary + COMMAND_ARGS[binary][type])
    type == "stdin" ? i.print(data) : out = o.read.strip
    [i, o, e].map(&:close)

    [
      p.value,
      type == "stdin" ? data : out
    ]
  end

  def unescape_newline(data)
    data.gsub(/\\n/, "\n").gsub(/\\r/, "\r")
  end
end
