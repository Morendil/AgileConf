require 'dm-core'
require 'dm-types'

class Video
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :thumb, Text
  property :media, Text
  property :player, String
  property :width, Integer
  property :height, Integer
  property :duration, String
  property :access, Enum[:public,:subscriber,:member], :default=>:member

  belongs_to :session
end