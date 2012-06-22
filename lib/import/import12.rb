require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/import/parser11.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

parser = Parser11.new "data/view-program2012.csv"
begin
  session = Session.from parser.hash
  session.year = 2012
  session.save
end while parser.shift
