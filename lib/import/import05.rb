require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/import/scraper05.rb"
require "./lib/import/session_import.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

stages = ["tutorials","experience_reports","workshops","research_papers","educators_symposium","intro_to_agile"]
stages.each do |stage|
  scraper = Scraper05.new stage
  begin
    session = Session.from scraper.hash
    session.year = 2005
    session.save
  end while scraper.shift
end
