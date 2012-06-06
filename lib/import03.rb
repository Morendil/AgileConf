require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/scraper03.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.auto_upgrade!

stages = ["tutorials","researchpapers","experiencereports","technicalexchange"]
stages.each do |stage|
  scraper = Scraper03.new stage
  begin
    session = Session.from scraper.hash
    session.year = 2003
    session.save
  end while scraper.shift
end