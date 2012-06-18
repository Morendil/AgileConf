require 'test/unit'

require "./lib/parser06.rb"

class TestParser11 < Test::Unit::TestCase

  def parser
    Parser06.new "data/Agile2006.csv"
  end 

  def test_title
    assert_equal "Are Agilists the Bonobos of Software Development?", parser[:title]
  end

  def test_desc
    assert parser[:description].include? "chimpanzees are aggressive"
  end

  def test_type
    assert_equal "Talk", parser[:type]
  end

  def test_stage
    assert_equal "Main", parser[:stage]
  end

  def test_speakers
    assert_equal ["Linda Rising"], parser[:speakers]
  end

  def test_records
    assert_equal ["TH1 Agilists are Bonobos2.ppt"], parser[:records]
  end

end
