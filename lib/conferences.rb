require 'dm-core'

require 'will_paginate'
require 'will_paginate/data_mapper'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/video.rb"
require "./lib/session_search.rb"

module AccessControl
  def lower_than actual, required
    all = [:public,:subscriber,:member]
    (all.index actual) < (all.index required)
  end
  def actual cookies
    result = :public
    result = :subscriber if (not cookies["SUBSCRIBER"].nil?)
    result = :member if (not cookies["MEMBERID"].nil?)
    result
  end
end

class SessionsBySpeaker
  def initialize id
    @id = id
  end
  def populate
    {:sessions => Speaker.get(@id).sessions}
  end
end

class ListSessions
  def initialize page, year=nil
    @page, @year = page, year
  end
  def populate
    params = {
      :page => @page,
      :per_page => 10,
      :order => [:year.desc, :stage.asc]
    }
    params[:year] = @year if @year
    {:sessions => Session.paginate(params)}
  end
end

class ListVideos
  include AccessControl
  def initialize access, cookies
    @access, @cookies = access.to_sym, cookies
  end
  def populate
    result = {}
    result[:sessions] = all_videos @access
    result[:notice] = @access if lower_than (actual @cookies), @access
    result
  end
  def all_videos access
    Session.all(
      Session.videos.access.lte => access,
      :order=>:year.desc,
      # Workaround for bug in DataMapper
      :fields=>[:year,:title,:id,:description,:stage,:type])
  end
end


class SearchSessions
  def initialize query, records, page
    @query, @records, @page = query, records, page
  end
  def populate
    query, records, page = @query, @records, @page
    search = Session.search do
      keywords query
      with :records, true if records
      paginate :page => page, :per_page => 10
    end
    {:sessions => search.results, :query => CGI.escapeHTML(@query)}
  end
end

class RelatedSessions
  def initialize id
    @id = id
  end
  def populate
    search = Session.get(@id).more_like_this do
      adjust_solr_params do |params|
        params[:rows] = 5
      end
    end
    {:sessions => search.results}
  end
end

class ShowSession
  include AccessControl
  def initialize id, cookies
    @id = id
    @cookies = cookies
  end
  def populate
    session = Session.first(:id => @id)
    result = {:session => session}
    if session.videos.any? then
      video = session.videos.first
      may_access = show_videos video
      if may_access then
        result[:player] = "video_#{video.player}".to_sym
        result[:video] = video
      else
        result[:notice] = video.access
      end
    end
    result[:speaker_list] = speaker_list session
    result
  end

  def show_videos video
    not lower_than (actual @cookies), video.access
  end

  def speaker_list session
    speakers_links = session.speakers.map do |speaker|
      "<a href='/speakers/#{speaker.id}/sessions'>#{speaker.name}</a>"
    end
    speakers_links.join(", ")
  end

end
