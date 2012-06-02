require 'test/unit'
require "./lib/scraper02.rb"

class TestScraper02 < Test::Unit::TestCase

  def test_title
    link = "http://web.archive.org/web/20030102083415/http://www.xpuniverse.com/schedule/Tutorial1"
    title = Scraper02.new(link).title
    assert_equal "XP IN A LEGACY ENVIRONMENT", title
  end

  def test_speakers
    link = "http://web.archive.org/web/20030102083415/http://www.xpuniverse.com/schedule/Tutorial1"
    assert_equal ["Kuryan Thomas", "Arlen Bankston"], Scraper02.new(link).speakers
  end

  def test_description
    link = "http://web.archive.org/web/20030102083415/http://www.xpuniverse.com/schedule/Tutorial1"
    assert Scraper02.new(link).description.include? "journey begins"
  end

  def test_type
    link = "http://web.archive.org/web/20030102083415/http://www.xpuniverse.com/schedule/Tutorial1"
    assert_equal Scraper02.new(link).type, "Tutorial"
  end

end
