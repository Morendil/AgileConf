require 'dm-core'

class Video
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :thumb, String
  property :media, String
  property :player, String
  property :width, Integer
  property :height, Integer
  property :duration, String

  belongs_to :session

  property :url, Text, :key => true
end