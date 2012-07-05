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
        :speakers=>[Speaker.new(:id=>1,:name=>"A"),Speaker.new(:id=>2,:name=>"B")]),
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

  def videos
    [
    Video.new(
      :thumb => "Vid1.jpg",
      :media => "http://cdn/File.flv",
      :player => "flv",
      :width => 520,
      :height => 390,
      :duration => "51:48"),
    Video.new(
        :media => "2f3429fcdc073",
        :player => "bit",
        :public => true,
        :width => 590,
        :height => 360,
        :duration => "30:00")
    ]
  end

end