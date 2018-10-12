require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/reloader'
require_relative '../blog'

class Web < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
  end

  after do
    ActiveRecord::Base.clear_active_connections!
  end

  get '/' do
    erb :index
  end

  post '/authors' do
    author_id = Sequent.new_uuid
    command = AddAuthor.from_params(params.merge(aggregate_id: author_id))
    Sequent.command_service.execute_commands command

    flash[:notice] = 'Account created'
    redirect "/authors/id/#{author_id}"
  end

  get '/authors/id/:aggregate_id' do
    @author = AuthorRecord.find_by(aggregate_id: params[:aggregate_id])
    erb :'authors/show'
  end

  get '/authors' do
    @authors = AuthorRecord.all
    erb :'authors/index'
  end

  helpers ERB::Util
end
