require 'test/unit'

require "./lib/import/scraper05.rb"

class TestScraper05 < Test::Unit::TestCase

  def scraper
    Scraper05.new "tutorials"
  end

  def test_items
    s = scraper
    assert_equal 32, s.items.length
    assert_equal "TU1", s.items.first
  end

 def test_title
    s = scraper
    assert_equal "Agile Project Management Reliable Innovation", scraper[:title]
    9.times {s.shift}
    assert_equal "Management Issues for Lean Software Development: Management Imperatives for the Successful Implementation of Lean Software", s[:title]
  end

  def test_desc
    s = scraper
    assert s[:description].start_with? "Symyx boasts"
    assert s[:description].end_with? "practices of APM."
  end

  def test_type
    assert_equal "Tutorial", scraper[:type]
  end

  def test_stage
    assert_equal "Tutorials", scraper[:stage]
  end

  def test_speakers
    assert_equal ["Jim Highsmith"], scraper[:speakers]
  end

  def test_records
    scraper = Scraper05.new "experience_reports"
    assert_equal ["XR1 - Agile Database Development Presentation.ppt",
 "XR1 - Agile Development of the Database.pdf"], scraper[:records]
  end

end
