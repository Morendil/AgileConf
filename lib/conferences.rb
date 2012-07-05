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
    private_show = session.videos.any? and @user
    public_show or private_show
  end

  def speaker_list session
    speakers_links = session.speakers.map do |speaker|
      "<a href='/speakers/#{speaker.id}/sessions'>#{speaker.name}</a>"
    end
    speakers_links.join(", ")
  end

end
