require 'rspec'
require 'rr'

RSpec.configure do |config|
  config.mock_with :rr
end

require "./lib/conferences.rb"
require "./lib/session.rb"
require "./lib/video.rb"

require "fixtures"

DataMapper.setup(:default,"in_memory://localhost")
DataMapper.finalize

describe "Accessing session content: " do
  include Fixtures

  before do
    @sessions = sessions
    @sessions[0].videos << videos[0]
    @sessions[1].videos << videos[1]
  end

  describe "when viewing session details as a visitor," do

    it "allows access to public videos" do
      mock(Session).first(:id=>"2") {@sessions[1]}
      command = ShowSession.new "2", nil
      results = command.populate
      results[:session].id.should == 2
      results[:player].should == :video_bit
    end

    it "does not allow access to other videos" do
      mock(Session).first(:id=>"1") {@sessions[0]}
      command = ShowSession.new "1", nil
      results = command.populate
      results[:session].id.should be 1
      results[:templates].should be nil
    end


  end

  describe "when viewing session details as a logged in member," do

    it "uses the appropriate player when playing older videos" do
      mock(Session).first(:id=>"1") {@sessions[0]}
      command = ShowSession.new "1", "MEMBERID"
      results = command.populate
      results[:session].id.should be 1
      results[:player].should == :video_flv
      results[:video].media.should == "http://cdn/File.flv"
    end

    it "uses the appropriate player when playing newer videos" do
      mock(Session).first(:id=>"2") {@sessions[1]}
      command = ShowSession.new "2", "MEMBERID"
      results = command.populate
      results[:session].id.should be 2
      results[:player].should == :video_bit
      results[:video].media.should == "2f3429fcdc073"
    end

  end
end
