require 'test/unit'

require "./lib/scraper03.rb"

class TestScraper03 < Test::Unit::TestCase

  def scraper
    link = "http://web.archive.org/web/20090607084452/http://agile2003.agilealliance.org/schedule/tutorials.html"
    Scraper03.new link
  end

  def test_items
    s = scraper
    assert_equal 16, s.items.length
    assert_equal "T1", s.items.first
  end

  def test_title
    s = scraper
    s.go "T4"
    assert_equal "XP/Agile Organizational Change - Tools for Successful Adoption", s[:title]
  end

end
