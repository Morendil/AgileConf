require 'rspec'
require 'dm-core'

require 'sinatra'
require 'tilt'

require "./lib/session.rb"

DataMapper.setup(:default,"in_memory://localhost")
DataMapper.finalize

describe "Displaying sessions: " do

  include Sinatra::Templates
  attr_reader   :template_cache

  before do
    @template_cache = Tilt::Cache.new
    @sessions = [
      Session.new(
        :id=>1,
        :title=>"Title",
        :stage=>"Its stage",
        :type=>"Its type",
        :description=>"Lorem\nipsum",
        :year=>"2012",
        :speakers=>[Speaker.new(:name=>"A"),Speaker.new(:name=>"B")]),
      Session.new(
        :id=>2,
        :title=>"Another",
        :stage=>"Its stage",
        :type=>"Its type",
        :description=>"Lorem\nipsum",
        :year=>"2011",
        :speakers=>[Speaker.new(:name=>"C"),Speaker.new(:name=>"D")]),
    ]
    @session = @sessions.first
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

  end

  describe "the sessions detail view" do

    it "shows a session's title" do
      result = erb :show, :views => "views/sessions"
      result.should include "<h1>Title</h1>"
    end

    it "shows a session's speakers as a comma separated list" do
      result = erb :show, :views => "views/sessions"
      result.should include "<h2>Presented by A, B</h2>"
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

end