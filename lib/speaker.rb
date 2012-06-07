require 'dm-core'
require 'will_paginate'
require 'will_paginate/data_mapper'

class Speaker
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :name, Text

  def self.from name
    Speaker.first_or_new(:name=>name)
  end
end