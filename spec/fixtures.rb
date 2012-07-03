require "./lib/session.rb"
require "./lib/video.rb"

module Fixtures
  def sessions
    [
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
  end

  def video
    Video.new(
      :thumb => "Vid1.jpg",
      :media => "http://cdn/File.flv",
      :player => "flv",
      :width => 520,
      :height => 390,
      :duration => "51:48")
  end

end