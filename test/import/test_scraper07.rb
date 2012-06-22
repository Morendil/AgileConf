require 'test/unit'

require "./lib/import/scraper07.rb"

class TestScraper07 < Test::Unit::TestCase

  def scraper
    Scraper07.new "http://agile2007.agilealliance.org/index.php%3Fpage=sub%252F&id=all.html"
  end

  def test_items
    s = scraper
    assert_equal 295, s.items.length
    assert_equal "1066", s.items.first
  end

 def test_title
    assert_equal "Research-In-Progress Workshop", scraper[:title]
  end

  def test_desc
    s = scraper
    s.shift
    assert s[:description].start_with? "Robert C. Martin, a founder"
    assert s[:description].end_with? "Whole Team."
  end

  def test_type
    s = scraper
    s.shift
    s.shift
    assert_equal "Experience Report", s[:type]
  end

  def test_stage
    s = scraper
    s.shift
    s.shift
    s.shift
    assert_equal "Testing", s[:stage]
  end

  def test_speakers
    s = scraper
    s.shift
    s.shift
    assert_equal ["Gerard Meszaros","Janice Aston"], s[:speakers]
  end

  def test_records
    s = scraper
    s.shift
    s.shift
    assert_equal ["http://agile2007.agilealliance.org/downloads/proceedings/029_Agile ERP_434.pdf","http://agile2007.agilealliance.org/downloads/presentations/Meszaros_-_Agile_ERP_-_Slides_434.pdf"], s[:records]
  end

end
