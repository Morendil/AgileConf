require 'dm-core'
require 'will_paginate'
require 'will_paginate/data_mapper'

class Record
  include DataMapper::Resource

  property :url, Text, :key => true

  def self.from url
    Record.new :url=>url
  end
end