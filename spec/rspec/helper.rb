unless %W(no false).include?(ENV["COVERAGE"])
  unless Gem::Specification.find_all_by_name('envygeeks-coveralls').empty?
    require 'envygeeks/coveralls'
  end

  SimpleCov.start do
    add_filter "/spec/"
  end
end

require "securerandom"
require "clippy"

def get_clipboard_contents
  out = ""

  Open3.popen3("xclip -o -selection clipboard") do |stdin, stdout, stderr, pid|
    out = stdout.read.strip
  end
out
end

def stub_binary(with = "xclip")
  clear_binary
  Clippy.send(:instance_variable_set, :@binary, with)
end

def clear_binary
  Clippy.send(:remove_instance_variable, :@binary) if Clippy.instance_variable_defined?(:@binary)
end
