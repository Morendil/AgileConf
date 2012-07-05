require 'dm-core'

class Video
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :thumb, Text
  property :media, Text
  property :player, String
  property :width, Integer
  property :height, Integer
  property :duration, String
  property :public, Boolean

  belongs_to :session
end