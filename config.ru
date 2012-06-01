require 'sinatra'

require 'dm-core'
require 'dm-migrations'

require 'sinatras-hat'

require "./lib/session.rb"

configure do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_upgrade!
end

Sinatra::Application.mount Session do
  finder { |model, params| model.paginate(:page => params[:page], :per_page => 10) }
  record { |model, params| model.first(:id => params[:id]) }
end

get('/') { redirect('/sessions') }

run Sinatra::Application
