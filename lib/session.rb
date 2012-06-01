require 'dm-core'
require 'will_paginate'
require 'will_paginate/data_mapper'

class Session
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :title, Text
  property :description, Text
  property :stage, String
  property :type, String
  property :year, Integer
end
