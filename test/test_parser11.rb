require 'test/unit'

require "./lib/parser11.rb"

class TestParser11 < Test::Unit::TestCase

  def parser
    Parser11.new "data/view-program2011.csv"
  end 

  def test_title
    assert_equal "Lean UX: Getting out of the deliverables business", parser[:title]
  end

  def test_desc
    assert parser[:description].include? "less emphasis on deliverables"
  end

  def test_type
    assert_equal "Talk", parser[:type]
  end

  def test_stage
    assert_equal "User Experience & Interaction Design", parser[:stage]
  end

  def test_speakers
    assert_equal ["Jeff Gothelf"], parser[:speakers
  end

end
