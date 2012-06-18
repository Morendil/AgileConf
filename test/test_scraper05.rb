# encoding: utf-8

require 'test/unit'

require "./lib/scraper05.rb"

class TestScraper04 < Test::Unit::TestCase

  def scraper
    Scraper05.new "apm"
  end

  def test_items
    s = scraper
    assert_equal 10, s.items.length
    assert_equal "TU1", s.items.first
  end

 def test_title
    s = scraper
    assert_equal "Agile Project Management--Reliable Innovation", scraper[:title]
    9.times {s.shift}
    assert_equal "How to integrate a Test/QA Team into an Agile Development Environment", s[:title]
  end

end
