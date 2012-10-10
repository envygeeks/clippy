$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
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
      subject.copy("example").must_equal("example")
    end
  end

  describe ".paste" do
    it "must be able to paste" do
      subject.copy("example")
      subject.paste.must_equal("example")
    end
  end

  describe ".clear" do
    it "should be able to clear the clipboard" do
      subject.copy("example")
      subject.clear.must_equal(true)
    end
  end
end