require 'rspec'
require 'dm-core'

require 'sinatra'
require 'tilt'
require 'capybara'

require "./lib/session.rb"
require "./lib/video.rb"

require "fixtures"

DataMapper.setup(:default,"in_memory://localhost")
DataMapper.finalize

describe "Displaying sessions: " do
  include Fixtures

  include Sinatra::Templates
  attr_reader   :template_cache

  before do
    @template_cache = Tilt::Cache.new
    @sessions = sessions
    @session = @sessions.first
  end

  def document rendered
    Capybara::Node::Simple.new(rendered)
  end

  describe "the sessions list view" do

    before do
      def @sessions.total_entries; self.length; end
      def will_paginate object; end
    end

    it "shows each session's title" do
      result = erb :index, :views => "views/sessions"
      result.should include ">Title</th>"
      result.should include ">Another</th>"
    end

    it "allows downloading records for sessions that have them" do
      @sessions[1].records = [Record.new(:url=>"A.PDF")]
      result = erb :index, :views => "views/sessions"
      link_path = "//table/tbody/tr/td[@class='description']//a"
      document(result).should have_xpath "#{link_path}[@href='A.PDF']"
    end

    it "indicates sessions that have been recorded on video" do
      @sessions[1].videos = [Video.new]
      result = erb :index, :views => "views/sessions"
      result.should include "(Video available to members)"
    end

    it "allows getting more information on each session" do
      result = erb :index, :views => "views/sessions"
      link_path = "//td[@class='description']//a"
      document(result).should have_xpath "#{link_path}[@href='/sessions/1']"
      document(result).should have_xpath "#{link_path}[@href='/sessions/2']"
    end

  end

  describe "the sessions detail view" do

    it "shows a session's title" do
      result = erb :show, :views => "views/sessions"
      result.should include "<h1>Title</h1>"
    end

    it "shows a session's speakers as a comma separated list" do
      @speaker_list = (ShowSession.new 1, nil).speaker_list @session
      result = erb :show, :views => "views/sessions"
      document(result).find("h2").text.should == "Presented by A, B"
    end

    it "links each speaker's name to a page listing all their sessions" do
      @speaker_list = (ShowSession.new 1, nil).speaker_list @session
      result = erb :show, :views => "views/sessions"
      document(result).find("h2/a[1]").text.should == "A"
      document(result).find("h2/a[1]/@href").text.should == "/speakers/1/sessions"
    end

    it "shows a session's stage" do
      result = erb :show, :views => "views/sessions"
      result.should include "<p><strong>Stage:</strong> Its stage</p>"
    end

    it "shows a session's type" do
      result = erb :show, :views => "views/sessions"
      result.should include "<p><strong>Session type:</strong> Its type</p>"
    end

    it "shows a session's conference year" do
      result = erb :show, :views => "views/sessions"
      result.should include "<p><strong>Conference:</strong> Agile 2012</p>"
    end

    it "shows a session's description, transforming line breaks" do
      result = erb :show, :views => "views/sessions"
      result.should include "<div>Lorem<br/>ipsum</div>"
    end

    it "doesn't list records if the session has none" do
      result = erb :show, :views => "views/sessions"
      result.should_not include "PDF"
      result.should_not include "PPT"
    end

    it "lists records and shows file type" do
      @session.records = [Record.new(:url=>"A.PDF"),Record.new(:url=>"b.zip")]
      result = erb :show, :views => "views/sessions"
      result.should include "<a href='A.PDF'>Download (pdf)</a>"
      result.should include "<a href='b.zip'>Download (zip)</a>"
    end

  end

  describe "the sessions video module" do

    it "embeds older sessions' associated videos, if any, in the Flash player" do
      @video = videos[0]
      result = erb :video_flv, :views => "views/sessions"
      result.should include "<OBJECT classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://macromedia.com/cabs/swflash.cab#version=8,0,0,0\" ID=flaMovie WIDTH=520 HEIGHT=390>"
      result.should include "<PARAM NAME=FlashVars VALUE=\"flvurl=http://cdn/File.flv\">"
      result.should include "<EMBED src=\"/assets/flvplayer520x390.swf\" FlashVars=\"flvurl=http://cdn/File.flv\" WIDTH=520 HEIGHT=390 TYPE=\"application/x-shockwave-flash\">"
    end

    it "embeds recent sessions' associated videos, if any, in a different player" do
      @video = videos[1]
      result = erb :video_bit, :views => "views/sessions"
      result.should include "<script src=\"http://vdassets.bitgravity.com/api/script\" type=\"text/javascript\"></script>"
      result.should include "viewNode(\"2f3429fcdc073\", {\"server_detection\": true, \"width\": 590, \"height\": 360});"    end

  end

end