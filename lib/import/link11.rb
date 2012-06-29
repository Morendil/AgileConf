require 'dm-core'
require 'dm-migrations'

require 'mechanize'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/record.rb"

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
DataMapper.auto_upgrade!

agent = Mechanize.new

login = agent.get "http://submit2011.agilealliance.org/"
login.forms.first['name'] = readline.strip
login.forms.first['pass'] = readline.strip
login.forms.first.submit

Session.all(:year=>2011).map do |session|
  page = agent.get "http://submit2011.agilealliance.org/node/#{session.id}"
  links = page./("//div[@class='session-pdf']/a/@href").map(&:text)
  links.map do |link|
    url = "http://submit2011.agilealliance.org#{link}"
    session.records << Record.new(:url=>url) unless link.start_with? "/session_ical"
  end
  session.save
end