require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/import/parser11.rb"
require "./lib/import/session_import.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

parser = Parser11.new "data/Agile2009.csv"
begin
  session = Session.from parser.hash
  session.id = 20090000+session.id
  session.year = 2009
  session.save
end while parser.shift
