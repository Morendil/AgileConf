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
    @session = Session.new(
      :title=>"Title",
      :stage=>"Its stage",
      :type=>"Its type",
      :description=>"Lorem\nipsum",
      :year=>"2012",
      :speakers=>[Speaker.new(:name=>"A"),Speaker.new(:name=>"B")])
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

    it "shows a session's description with line breaks" do
      result = erb :show, :views => "views/sessions"
      result.should include "<div>Lorem<br/>ipsum</div>"
    end

  end

end