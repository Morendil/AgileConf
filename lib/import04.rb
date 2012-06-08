require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/scraper04.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

stages = ["tutorials","researchp","expreports","peertopeer"]
stages.each do |stage|
  scraper = Scraper04.new stage
  begin
    session = Session.from scraper.hash
    session.year = 2004
    session.save
  end while scraper.shift
end