require 'sinatra'

require 'dm-core'
require 'dm-migrations'

require "./lib/session.rb"

configure do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

get('/') { redirect('/sessions') }

get '/sessions' do
  @sessions = Session.paginate(:page => params[:page], :per_page => 10)
  erb :index, :views => "views/sessions"
end

get '/sessions/:id' do
  @session = Session.first(:id => params[:id])
  erb :show, :views => "views/sessions"
end

run Sinatra::Application
