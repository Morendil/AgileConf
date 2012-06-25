require 'dm-core'
require 'will_paginate'
require 'will_paginate/data_mapper'

class Record
  include DataMapper::Resource

  belongs_to :session

  property :url, Text, :key => true
end