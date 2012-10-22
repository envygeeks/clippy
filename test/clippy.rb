$:.unshift(File.expand_path("../../lib", __FILE__))

require "simplecov"
SimpleCov.start do
  command_name 'Minitest'
end

require "minitest/autorun"
require "minitest/spec"
require "minitest/pride"
require "clippy"

class Clippy
  class << self
    def _this_is_just_another_test
      @@encode = true; clear
    end
  end
end

describe Clippy do
  after(:each) { Clippy._this_is_just_another_test }
  subject { Clippy }

  it "must have a proper version" do
    Clippy.version.split(".").delete_if { |val|
      val =~ /pre\d+/ }.length.must_equal(3)
  end

  describe ".encode=" do
    it "should allow you to disable encoding" do
      assert(!(Clippy.encode = false))
    end
  end

  describe ".copy" do
    it "must be able to copy" do
      assert_equal("example1", subject.copy("example1"))
    end

    it "it must copy from the binary" do
      data, status = "example2", 1
      Open3.popen3(File.expand_path("../../bin/clippy --copy", __FILE__)) do
      |stdin, _, _, thread|
        stdin << data
        stdin.close
        status = thread.value
      end

      assert_equal(0, status)
      assert_equal("example2", subject.paste)
    end
  end

  describe ".paste" do
    it "better properly encode a string" do
      assert((subject.encode = true))
      assert_equal("example3", subject.copy("example3"))
      example = subject.paste("Windows-1251")
      assert_equal("example3", example)
      assert_equal("Windows-1251", example.encoding.name)
    end

    it "should refuse to support a non-supported encoding" do
      assert_raises(Clippy::InvalidEncoding) { subject.paste("example4") }
    end

    it "must be able to paste" do
      assert_equal("example5", subject.copy("example5"))
      assert_equal("example5", subject.paste)
    end

    it "must be able to paste from the binary" do
      data, status = "", 1
      assert_equal("example6", subject.copy("example6"))
      Open3.popen3(File.expand_path("../../bin/clippy --paste", __FILE__)) {
      |_, stdout, _, thread|
        data = stdout.read; status = thread.value }

      assert_equal(0, status)
      assert_equal("example6", data.strip)
    end

    it "pastes from clipboard" do
      assert_equal("example7", subject.copy("example7"))
      assert_equal("example7", subject.paste("clipboard"))
    end

    it "pastes from primary" do
      assert_equal("example8", subject.copy("example8"))
      assert_equal("example8", subject.paste("primary"))
    end

    it "pastes from seconary" do
      assert_equal("example9", subject.copy("example9"))
      assert_equal("example9", subject.paste("secondary"))
    end
  end

  describe ".clear" do
    it "should be able to clear the clipboard" do
      assert_equal("example10", subject.copy("example10"))
      assert(subject.clear)
    end
  end
end
