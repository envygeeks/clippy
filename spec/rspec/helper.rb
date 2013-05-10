unless %W(no false).include?(ENV["COVERAGE"])
  require "simplecov"
  require "coveralls"

  module Coveralls
    NoiseBlacklist = [
      "[Coveralls] Using SimpleCov's default settings.".green,
      "[Coveralls] Set up the SimpleCov formatter.".green,
      "[Coveralls] Outside the Travis environment, not sending data.".yellow
    ]

    def puts(message)
      # Only prevent the useless noise on our terminals, not inside of the Travis or Circle CI.
      unless NoiseBlacklist.include?(message) || ENV["TRAVIS"] == "true" || ENV["CI"] == "true"
        $stdout.puts message
      end
    end
  end

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
        Coveralls::SimpleCov::Formatter
  ]

  Coveralls.noisy = true
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require "securerandom"
require "clippy"

def get_clipboard_contents() out = ""
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
