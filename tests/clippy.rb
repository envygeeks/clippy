$:.unshift(File.expand_path("../../lib", __FILE__))
unless defined?(Gem) then require 'rubygems' end
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'clippy'

describe Clippy do subject { Clippy }
  it "must have a proper version" do
    Clippy.version.split(".").delete_if { |val|
      val =~ /pre\d+/ }.length.must_equal(3)
  end

  describe ".copy" do
    it "must be able to copy" do
      subject.clear.must_equal(true)
      subject.copy("example").must_equal("example")
    end

    it "it must copy from the binary" do
      subject.clear.must_equal(true)
      data, status = "example", 1
      Open3.popen3(File.expand_path("../../bin/clippy --copy", __FILE__)) do
      |stdin, _, _, thread|
        stdin << data
        stdin.close
        status = thread.value
      end

      status.must_equal(0)
      subject.paste.must_equal("example")
    end
  end

  describe ".paste" do
    it "must be able to paste" do
      subject.clear.must_equal(true)
      subject.copy("example")
      subject.paste.must_equal("example")
    end

    it "must be able to paste from the binary" do
      subject.clear.must_equal(true)
      data, status = "", 1
      subject.copy("example").must_equal("example")
      Open3.popen3(File.expand_path("../../bin/clippy --paste", __FILE__)) {
      |_, stdout, _, thread|
        data = stdout.read; status = thread.value }

      status.must_equal(0)
      data.strip.must_equal("example")
    end
  end

  describe ".clear" do
    it "should be able to clear the clipboard" do
      subject.copy("example")
      subject.clear.must_equal(true)
    end
  end
end