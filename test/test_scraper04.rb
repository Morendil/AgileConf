# encoding: utf-8

require 'test/unit'

require "./lib/scraper04.rb"

class TestScraper04 < Test::Unit::TestCase

  def scraper
    s = Scraper04.new "expreports"
  end

  def test_items
    s = Scraper04.new "expreports"
    assert_equal 14, s.items.length
    assert_equal "XR1-1", s.items.first
    s = Scraper04.new "peertopeer"
    assert_equal 16, s.items.length
    assert_equal "PP1", s.items.first
  end

  def test_title
    assert_equal "XP \"Anti-Practices\" : anti-patterns for XP practices", scraper[:title]
  end

  def test_stage
    assert_equal "Process Evolution (XR1)", scraper[:stage]
  end

  def test_type
    assert_equal "Experience Report", scraper[:type]
  end

  def test_description_format1
    s = Scraper04.new "expreports"
    description = s[:description]
    assert !(description.include? "\t")
    assert description.include? "share the counter plans"
  end

  def test_description_format2
    s = Scraper04.new "peertopeer"
    description = s[:description]
    assert !(description.include? "\t")
    assert description.start_with? "The books on"
    assert description.end_with? "explore the areas in depth."
  end

  def test_record
    s = scraper
    assert_equal ["http://agile2004.agilealliance.org/files/XR1-1.pdf"], s[:records]
    s = Scraper04.new "tutorials"
    assert_equal [], s[:records]
  end

  def test_speakers
    s = Scraper04.new "researchp"
    assert_equal ["Laurie Williams","Anuja Shukla","Annie Antón"], s[:speakers]
  end

end
