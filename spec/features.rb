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
      mock(Session).all(Session.videos.access.lte=>:public) {[@videos.first]}
      command = ListVideos.new :public, {}
      results = command.populate
      results[:sessions].length.should be 1
      results[:sessions].first.id.should be 1
    end

    it "puts up a newsletter sign-up notice if a visitor requests subscriber videos" do
      command = ListVideos.new :subscriber, {}
      results = command.populate
      results[:sessions].should be nil
      results[:notice].should be :subscriber
    end

    it "lists subscriber videos when requested by a subscriber" do
      mock(Session).all(Session.videos.access.lte=>:subscriber) {@ sessions[0..1]}
      command = ListVideos.new :subscriber, {"SUBSCRIBER"=>"YES"}
      results = command.populate
      results[:sessions].length.should be 2
    end

    it "lists subscriber videos when requested by a member" do
      mock(Session).all(Session.videos.access.lte=>:subscriber) {@ sessions[0..1]}
      command = ListVideos.new :subscriber, {"MEMBERID"=>"DC"}
      results = command.populate
      results[:sessions].length.should be 2
    end

    it "puts up a sign-up notice if a subscriber requests member videos" do
      command = ListVideos.new :member, {}
      results = command.populate
      results[:sessions].should be nil
      results[:notice].should be :member
    end

    it "lists member videos when requested by a member" do
      mock(Session).all(Session.videos.access.lte=>:member) {@sessions[0..2]}
      command = ListVideos.new :member, {"MEMBERID"=>"DC"}
      results = command.populate
      results[:sessions].length.should be 3
    end

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
