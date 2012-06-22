require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/import/parser08.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

parser = Parser08.new "data/Agile2008.csv"
begin
  session = Session.from parser.hash
  session.id = 20080000+session.id
  session.year = 2008
  session.save
end while parser.shift
