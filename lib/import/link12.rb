require 'csv'

require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/record.rb"
require "./lib/video.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
DataMapper.auto_upgrade!

file = "data/Agile2012-files.csv"
csv = CSV.open(file,:headers=>true)

while row = csv.shift do
  pres = row["Presentation"] || "NO"
  session = Session.get(row["id"])
  puts "#{row["id"]} missing" if session.nil?
  next if session.nil?
  next unless pres.start_with? "http"
  session.records << Record.new(:url=>pres)
  session.save
end
