require 'dm-core'
require 'will_paginate'
require 'will_paginate/data_mapper'

class Speaker
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, Text

  has n, :sessions, :through => Resource
end