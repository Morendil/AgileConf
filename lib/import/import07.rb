require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/import/scraper07.rb"
require "./lib/import/session_import.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

scraper = Scraper07.new "http://agile2007.agilealliance.org/index.php%3Fpage=sub%252F&id=all.html"
begin
  session = Session.from scraper.hash
  session.id = 20070000+scraper.id
  session.year = 2007
  session.save
end while scraper.shift
