require 'test/unit'
require "./lib/scraper02.rb"

class TestScraper02 < Test::Unit::TestCase

  def scraper
    archive = "http://web.archive.org/web/20030102083415/"
    link = "#{archive}http://www.xpuniverse.com/schedule/Tutorial1"
    Scraper02.new(link)
  end

  def test_title
    assert_equal "XP IN A LEGACY ENVIRONMENT", scraper[:title]
  end

  def test_stage
    assert_equal "Main conference", scraper[:stage]
  end

  def test_speakers
    assert_equal ["Kuryan Thomas", "Arlen Bankston"], scraper[:speakers]
  end

  def test_description
    assert scraper[:description].start_with? "Summary"
    assert scraper[:description].include? "journey begins"
  end

  def test_type
    assert_equal "Tutorial", scraper[:type]
  end

end
