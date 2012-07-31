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

get '/sessions/?' do
  populate_from ListSessions.new params[:page]
  do_render :index, :sessions
end

get '/sessions/year/:year/?' do
  populate_from ListSessions.new params[:page], params[:year]
  do_render :index, :sessions
end

get '/learning-center/?' do
   erb :learning_center
end

get '/learning-center/:access/?' do
  populate_from ListVideos.new params[:access], request.cookies
  @notice = erb @notice, :layout=> false if @notice
  do_render :videos, :sessions
end

get '/sessions/search/?' do
  populate_from SearchSessions.new params[:query], params[:records], params[:page]
  do_render :index, :sessions
end

get('/speakers/:id/?') { redirect('/speakers/#{params[:id]}/sessions') }

get '/speakers/:id/sessions/?' do
  populate_from SessionsBySpeaker.new params[:id]
  do_render :index, :sessions
end

get '/sessions/:id/?' do
  populate_from ShowSession.new params[:id], request.cookies
  @embed = erb @player, :views => "views/sessions", :layout=>false if @player
  do_render :show, :sessions
end

get '/sessions/:id/video?' do
  populate_from ShowSession.new params[:id], request.cookies
  @embed = erb @player, :views => "views/sessions", :layout=>false if @player
  @notice = erb @notice, :layout=> false if @notice
  do_render :show, :sessions
end

get '/sessions/:id/related/?' do
  populate_from RelatedSessions.new params[:id]
  erb :related, :views => "views/sessions", :layout => false
end

get '/reindex' do
    Session.all.map {|each| each.remove_from_index!; each.index!}
    "Reindexing..."
end

get '/assets/*' do |file|
  send_file File.join('.',request.path)
end

run Sinatra::Application
