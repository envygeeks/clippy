$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'minitest/pride'
require 'minitest/spec'
require 'minitest/autorun'

require 'clippy'

describe Clippy do
  it "should be a singleton" do
    Clippy.private_methods.include?(:new).must_equal(true)
  end

  it "should have a proper version number" do
    Clippy.version.split(/\./).delete_if do
    |val|
      val =~ /pre\d{0,2}/
    end.length.must_equal(2)
  end

  describe "when asked to copy, paste or clear" do
    it "should copy and paste" do
      test1 = Clippy.copy("Test1")
      test1.must_equal("Test1")
      Clippy.paste.must_equal("Test1")
    end

    it "should also be able to clear" do
      Clippy.copy("Test2")
      Clippy.clear.must_equal(false)
      Clippy.paste.must_equal(false)
    end
  end
end
