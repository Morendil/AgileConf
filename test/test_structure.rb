require 'test/unit'

require 'dm-core'
DataMapper.setup(:default,:adapter=>:in_memory)

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/record.rb"
DataMapper.finalize

class TestStructure < Test::Unit::TestCase

  def test_add_speakers
    values = {:id=>"1",:title=>"Foo",:description=>"Bar",:speakers=>["A","B"]}
    session = Session.from values
    session.save
    assert_equal "Foo", session.title
    assert_equal 2, session.speakers.all.length
    assert_equal "A", session.speakers.first.name
  end

  def test_add_records
    values = {:id=>"1",:title=>"Foo",:records =>["A","B"],:speakers=>[]}
    session = Session.from values
    session.save
    assert_equal "Foo", session.title
    assert_equal 2, session.records.all.length
    assert_equal "A", session.records.first.url
  end

end
