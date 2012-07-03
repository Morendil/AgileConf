require 'dm-core'

require 'will_paginate'
require 'will_paginate/data_mapper'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/video.rb"
require "./lib/session_search.rb"

class ListSessions
  def initialize page
    @page = page
  end
  def populate
    {:sessions => Session.paginate(
      :page => @page,
      :per_page => 10,
      :order => [:year.desc, :stage.asc])}
  end
end

class SearchSessions
  def initialize query
    @query = query
  end
  def populate
    search = Session.search do
      keywords params[:query]
      with :records, true if params[:records]
      paginate :page => params[:page], :per_page => 10
    end
    {:sessions => search.results, :query => CGI.escapeHTML(@query)}
  end
end

class ShowSession
  def initialize id, user
    @id = id
    @user = user
  end
  def populate
    session = Session.first(:id => @id)
    result = {:session => session}
    if @user and session.videos.any? then
      video = session.videos.first
      result[:player] = "video_#{video.player}"
      result[:video] = video
    end
    result
  end
end
