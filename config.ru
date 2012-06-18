require 'sinatra'

require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"
require "./lib/speaker.rb"

configure do
  DataMapper.finalize
  Sunspot.config.solr.url = ENV['SOLR_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

get('/') { redirect('/sessions') }

get '/sessions' do
  @sessions = Session.paginate(:page => params[:page], :per_page => 10)
  erb :index, :views => "views/sessions", :layout => :'../layout'
end

post '/sessions' do
  search = Session.search do
    keywords params[:query]
  end
  @sessions = search.results
  erb :index, :views => "views/sessions", :layout => :'../layout'
end

get '/sessions/:id' do
  @session = Session.first(:id => params[:id])
  erb :show, :views => "views/sessions", :layout => :'../layout'
end

get '/assets/*' do |file|
  send_file File.join('.',request.path)
end

run Sinatra::Application
