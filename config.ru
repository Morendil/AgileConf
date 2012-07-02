require 'sinatra'

require 'dm-core'
require 'dm-migrations'

require 'will_paginate'
require 'will_paginate/data_mapper'

require "./lib/session.rb"
require "./lib/speaker.rb"
require "./lib/session_search.rb"

configure do
  DataMapper.finalize
  Sunspot.config.solr.url = ENV['SOLR_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

get('/') { redirect('/sessions') }

get '/sessions' do
  @sessions = Session.paginate(
    :page => params[:page],
    :per_page => 10,
    :order => [:year.desc, :stage.asc])
  erb :index, :views => "views/sessions", :layout => :'../layout'
end

get '/sessions/search' do
  @query = CGI.escapeHTML(params[:query])
  search = Session.search do
    keywords params[:query]
    paginate :page => params[:page], :per_page => 10
  end
  @sessions = search.results
  erb :index, :views => "views/sessions", :layout => :'../layout'
end

get '/sessions/:id' do
  @session = Session.first(:id => params[:id])
  erb :show, :views => "views/sessions", :layout => :'../layout'
end

get '/reindex' do
    Session.all.map {|each| each.remove_from_index!; each.index!}
end

get '/assets/*' do |file|
  send_file File.join('.',request.path)
end

run Sinatra::Application
