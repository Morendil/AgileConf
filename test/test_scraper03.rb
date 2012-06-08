require 'test/unit'

require "./lib/scraper03.rb"

class TestScraper03 < Test::Unit::TestCase

  def scraper
    Scraper03.new "tutorials"
  end

  def test_items
    s = scraper
    assert_equal 16, s.items.length
    assert_equal "T1", s.items.first
  end

  def test_title
    s = scraper
    5.times do s.shift end
    assert_equal "XP/Agile Organizational Change - Tools for Successful Adoption", s[:title]
  end

  def test_speakers
    # 2003 has really stupid formatting for speaker names... fix afterward
    s = scraper
    5.times do s.shift end
    assert_equal ["Diana Larsen","Joshua Kerievsky"], s[:speakers]
  end

  def test_stage
    s = scraper
    assert_equal "Tutorials", s[:stage]
  end

  def test_description
    description = scraper[:description]
    assert description.include? "Information Age"
    assert !(description.include? "\t")
  end

  def test_record
    s = scraper
    13.times do s.shift end
    assert_equal ["http://agile2003.agilealliance.org/files/T17Slides.ppt"], s[:records]
  end

  def test_records
    s = Scraper03.new "researchpapers"
    assert_equal ["http://agile2003.agilealliance.org/files/P1Paper.pdf","http://agile2003.agilealliance.org/files/P1Slides.pdf"], s[:records]
  end

end
