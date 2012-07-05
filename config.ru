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

helpers do
  def populate_from command
    values = command.populate
    values.each do |key,value| 
      self.instance_variable_set "@#{key}", value
    end
  end

  def do_render template, controller
    erb template, :views => "views/#{controller}", :layout => :'../layout'
  end
end

get '/' do
  populate_from ListSessions.new params[:page]
  @intro = erb :intro, :layout => false unless params[:page]
  do_render :index, :sessions
end

get '/sessions' do
  populate_from ListSessions.new params[:page]
  do_render :index, :sessions
end

get '/sessions/search' do
  populate_from SearchSessions.new params[:query], params[:records], params[:page]
  do_render :index, :sessions
end

get '/speakers/:id/sessions' do
  populate_from SessionsBySpeaker.new params[:id]
  do_render :index, :sessions
end

get '/sessions/:id' do
  populate_from ShowSession.new params[:id], request.cookies["MEMBERID"]
  @embed = erb @player, :views => "views/sessions" if @player
  do_render :show, :sessions
end

get '/reindex' do
    Session.all.map {|each| each.remove_from_index!; each.index!}
    "Reindexing..."
end

get '/assets/*' do |file|
  send_file File.join('.',request.path)
end

run Sinatra::Application
