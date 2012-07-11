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
    @videos = videos
    @sessions[0].videos << @videos[0]
    @sessions[1].videos << @videos[1]
    @sessions[2].videos << @videos[2]
    @videos[0].session = @sessions[0]
    @videos[1].session = @sessions[1]
    @videos[2].session = @sessions[2]
  end

  describe "when viewing the three sections of the VLC, depending on access:" do

    it "lists all public videos, irrespective of access level" do
      command = ListVideos.new :public, {}
      mock(command).all_videos(:public) {[@sessions.first]}
      results = command.populate
      results[:sessions].length.should == 1
      results[:sessions].first.id.should == 1
    end

    it "adds a newsletter notice if a visitor requests subscriber videos" do
      command = ListVideos.new :subscriber, {}
      mock(command).all_videos(:subscriber) {@sessions[0..1]}
      results = command.populate
      results[:sessions].length.should == 2
      results[:notice].should == :subscriber
    end

    it "just lists subscriber videos when requested by a subscriber" do
      command = ListVideos.new :subscriber, {"SUBSCRIBER"=>"YES"}
      mock(command).all_videos(:subscriber) {@sessions[0..1]}
      results = command.populate
      results[:sessions].length.should == 2
      results[:notice].should be nil
    end

    it "just lists subscriber videos when requested by a member" do
      command = ListVideos.new :subscriber, {"MEMBERID"=>"DC"}
      mock(command).all_videos(:subscriber) {@sessions[0..1]}
      results = command.populate
      results[:sessions].length.should == 2
      results[:notice].should be nil
    end

    it "adds a sign-up notice if a subscriber requests member videos" do
      command = ListVideos.new :member, {}
      mock(command).all_videos(:member) {@sessions[0..2]}
      results = command.populate
      results[:sessions].length.should == 3
      results[:notice].should be :member
    end

    it "just lists member videos when requested by a member" do
      command = ListVideos.new :member, {"MEMBERID"=>"DC"}
      mock(command).all_videos(:member) {@sessions[0..2]}
      results = command.populate
      results[:sessions].length.should == 3
      results[:notice].should be nil
    end

  end

  describe "when viewing session details," do

    it "allows access to public videos if not logged in" do
      mock(Session).first(:id=>"1") {@sessions[0]}
      command = ShowSession.new "1", {}
      results = command.populate
      results[:session].id.should == 1
      results[:player].should == :video_flv
      results[:notice].should be nil
    end

    it "does not allow access to subscriber videos if not logged in" do
      mock(Session).first(:id=>"2") {@sessions[1]}
      command = ShowSession.new "2", {}
      results = command.populate
      results[:session].id.should be 2
      results[:player].should be nil
      results[:notice].should == :subscriber
    end

    it "shows subscriber videos if logged in as subscriber" do
      mock(Session).first(:id=>"2") {@sessions[1]}
      command = ShowSession.new "2", {"SUBSCRIBER"=>"YES"}
      results = command.populate
      results[:session].id.should == 2
      results[:player].should == :video_bit
      results[:notice].should be nil
    end

    it "shows subscriber videos if logged in as member" do
      mock(Session).first(:id=>"2") {@sessions[1]}
      command = ShowSession.new "2", {"MEMBERID"=>"DC"}
      results = command.populate
      results[:session].id.should == 2
      results[:player].should == :video_bit
      results[:notice].should be nil
    end

    it "does not allow access to member videos if logged in as subscriber" do
      mock(Session).first(:id=>"3") {@sessions[2]}
      command = ShowSession.new "3", {"SUBSCRIBER"=>"YES"}
      results = command.populate
      results[:session].id.should be 3
      results[:player].should be nil
      results[:notice].should == :member
    end

    it "shows subscriber videos if logged in as member" do
      mock(Session).first(:id=>"3") {@sessions[2]}
      command = ShowSession.new "3", {"MEMBERID"=>"DC"}
      results = command.populate
      results[:session].id.should == 3
      results[:player].should == :video_bit
      results[:notice].should be nil
    end

  end

  describe "when viewing session details with video embedded," do

    it "uses the appropriate player when playing older videos" do
      mock(Session).first(:id=>"1") {@sessions[0]}
      command = ShowSession.new "1", {"MEMBERID"=>"DC"}
      results = command.populate
      results[:session].id.should be 1
      results[:player].should == :video_flv
      results[:video].media.should == "http://cdn/File.flv"
    end

    it "uses the appropriate player when playing newer videos" do
      mock(Session).first(:id=>"2") {@sessions[1]}
      command = ShowSession.new "2", {"MEMBERID"=>"DC"}
      results = command.populate
      results[:session].id.should be 2
      results[:player].should == :video_bit
      results[:video].media.should == "2f3429fcdc073"
    end

  end
end
