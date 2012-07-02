require 'dm-core'

class Speaker
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, Text

  has n, :sessions, :through => Resource
end