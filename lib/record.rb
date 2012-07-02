require 'dm-core'

class Record
  include DataMapper::Resource

  belongs_to :session

  property :url, Text, :key => true
end