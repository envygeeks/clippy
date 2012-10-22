require "rbconfig"

class Clippy
  private_class_method :new
  @@encode = true
  [:UnsupportedOS, :UnknownClipboard, :InvalidEncoding].each { |status|
    const_set(status, Class.new(StandardError)) }
  HOST_OS = RbConfig::CONFIG["host_os"]
end

require "clippy/version"
require "clippy/common"

if Clippy::HOST_OS !~ /mswin|mingw32/
  require "clippy/os/#{Clippy::HOST_OS =~ /darwin/ ? "osx" : "linux"}"
  require "clippy/os/linux_and_osx.rb"
  require "open3"
else
  require "clippy/windows"
  require "Win32API"
  require "tempfile"
end
