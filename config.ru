require 'sinatra'

require 'dm-core'
require 'dm-migrations'

require 'will_paginate'

require "./lib/conferences.rb"

configure do
  DataMapper.finalize
  Sunspot.config.solr.url = ENV['SOLR_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

def populate_from command
  values = command.populate
  values.each do |key,value| 
    self.instance_variable_set "@#{key}", value
  end
  @embed = render @player, "sessions" if @player
end

def render template, controller
  erb :template, :views => "views/#{controller}", :layout => :'../layout'
end

get('/') { redirect('/sessions') }

get '/sessions' do
  populate_from ListSessions.new
  render :index, :sessions
end

get '/sessions/search' do
  populate_from SearchSessions.new
  render :index, :sessions
end

get '/sessions/:id' do
  populate_from ShowSession.new params[:id], request.cookies["MEMBERID"]
  render :show, :sessions
end

get '/reindex' do
    Session.all.map {|each| each.remove_from_index!; each.index!}
    "Reindexing..."
end

get '/assets/*' do |file|
  send_file File.join('.',request.path)
end

run Sinatra::Application
