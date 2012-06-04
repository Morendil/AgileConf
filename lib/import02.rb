require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/scraper02.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

all = File.readlines("data/2002.txt")
all.each do |link|
  begin
    scraper = Scraper02.new link
    session = Session.from scraper.hash
    session.year = 2002
    session.save
  rescue
    puts link
  end
end
