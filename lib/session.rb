require 'dm-core'
require 'will_paginate'
require 'will_paginate/data_mapper'

require "./lib/speaker.rb"
require "./lib/record.rb"

class Session
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :title, Text
  property :description, Text
  property :stage, String
  property :type, String
  property :year, Integer

  has n, :speakers, :through => Resource
  has n, :records

  def self.from hash
    speakers = (hash.delete :speakers) || []
    records = (hash.delete :records) || []
    result = Session.new hash
    speakers.each do |speaker|
      adding = (Speaker.from speaker)
      result.speakers << adding unless result.speakers.include? adding
    end
    records.each do |record|
      result.records << (Record.from record)
    end
    result
  end

end
