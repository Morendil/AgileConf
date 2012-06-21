require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/import/parser06.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

parser = Parser06.new "data/Agile2006.csv"
begin
  session = Session.from parser.hash
  session.year = 2006
  session.save
end while parser.shift
