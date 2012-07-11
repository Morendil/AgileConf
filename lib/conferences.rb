require 'dm-core'

require 'will_paginate'
require 'will_paginate/data_mapper'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/video.rb"
require "./lib/session_search.rb"

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
  def initialize access, cookies
    @access, @cookies = access.to_sym, cookies
  end
  def populate
    member = (not @cookies["MEMBERID"].nil?)
    subscriber = (member or (not @cookies["SUBSCRIBER"].nil?))
    result = {}
    result[:sessions] = all_videos :public if @access == :public
    result[:sessions] = all_videos :subscriber if @access == :subscriber and subscriber
    result[:sessions] = all_videos :member if @access == :member and member
    result[:notice] = @access if not result[:sessions]
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
  def initialize id, user
    @id = id
    @user = user
  end
  def populate
    session = Session.first(:id => @id)
    result = {:session => session}
    if show_videos session then
      video = session.videos.first
      result[:player] = "video_#{video.player}".to_sym
      result[:video] = video
    end
    result[:speaker_list] = speaker_list session
    result
  end

  def show_videos session
    public_show = session.videos.any? {|v| v.public}
    private_show = (@user and session.videos.any?)
    public_show or private_show
  end

  def speaker_list session
    speakers_links = session.speakers.map do |speaker|
      "<a href='/speakers/#{speaker.id}/sessions'>#{speaker.name}</a>"
    end
    speakers_links.join(", ")
  end

end
