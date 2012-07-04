require "./lib/dm_sunspot.rb"

class Session
  include Sunspot::DataMapper

  searchable do
    text		:title
    text		:description, :more_like_this => true
    text		:speakers do
      speakers.map(&:name).join " "
    end
    text		:stage
    text		:type
    integer		:year
    boolean	:records do
      records.any? || videos.any?
    end
  end

end
