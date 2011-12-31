$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
unless defined?(Gem) then require 'rubygems' end
require 'minitest/autorun'
require 'minitest/pride'
require 'clippy'

class TestClippy < MiniTest::Unit::TestCase

  def test1_version
    Clippy.version.split(/\./).delete_if do
    |val|
      val =~ /pre\d{0,2}/
    end.length.must_equal(3)
  end

  def test2_copy
    test1 = Clippy.copy("Test1")
    test1.must_equal("Test1")
    Clippy.paste.must_equal("Test1")
  end

  def test3_paste
    test1 = Clippy.copy("Test2")
    test1.must_equal("Test2")
    Clippy.paste.must_equal("Test2")
  end

  def test4_clear
    Clippy.copy("Test2")
    Clippy.clear.must_equal(false)
    Clippy.paste.must_equal(false)
  end
end
