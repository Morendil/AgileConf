require 'dm-core'

require "./lib/speaker.rb"
require "./lib/record.rb"
require "./lib/import/session_import.rb"

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
end
