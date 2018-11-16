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
    @command = AddAuthor.from_params(params.merge(aggregate_id: author_id))
    Sequent.command_service.execute_commands @command

    flash[:notice] = 'Account created'
    redirect "/authors/id/#{author_id}"
  rescue Sequent::Core::CommandNotValid => e
    @errors = e.errors
    erb :index
  rescue Usernames::UsernameAlreadyRegistered
    @errors = {email: ['already registered, please choose another']}
    erb :index
  end

  get '/authors/id/:author_id' do
    @author = AuthorRecord.find_by(aggregate_id: params[:author_id])
    erb :'authors/show'
  end

  get '/authors' do
    @authors = AuthorRecord.all
    erb :'authors/index'
  end

  post '/authors/id/:author_id/post' do
    post_id = Sequent.new_uuid

    @command = AddPost.from_params(
      params.merge(
        aggregate_id: post_id,
        author_aggregate_id: params[:author_id],
      )
    )
    Sequent.command_service.execute_commands @command

    flash[:notice] = 'Post created'

    redirect "/authors/id/#{params[:author_id]}/post/#{post_id}"
  rescue Sequent::Core::CommandNotValid => e
    @author = AuthorRecord.find_by(aggregate_id: params[:author_id])
    @errors = e.errors
    erb :'authors/show'
  end

  get '/authors/id/:author_id/post/:post_id' do
    @author = AuthorRecord.find_by(aggregate_id: params[:author_id])
    post_record = PostRecord.find_by(aggregate_id: params[:post_id])
    @command = EditPost.new(
      aggregate_id: params[:post_id],
      title: post_record.title,
      content: post_record.content,
    )
    erb :'authors/show'
  end

  post '/authors/id/:author_id/post/:post_id' do
    @command = EditPost.from_params(
      params.merge(
        aggregate_id: params[:post_id],
      )
    )

    Sequent.command_service.execute_commands @command
    flash[:notice] = 'Post saved'
    redirect back
  rescue Sequent::Core::CommandNotValid => e
    @author = AuthorRecord.find_by(aggregate_id: params[:author_id])
    @errors = e.errors
    erb :'authors/show'
  end

  helpers ERB::Util

  helpers do
    def has_errors_for(attribute)
      @errors && @errors[attribute].present?
    end

    def errors(attribute)
      @errors[attribute] if has_errors_for(attribute)
    end

    def error_css_class(attribute)
      has_errors_for(attribute) ? 'is-invalid' : ''
    end

    def post_action(command)
      @command&.is_a?(EditPost) ? "/authors/id/#{params[:author_id]}/post/#{command.aggregate_id}" : "/authors/id/#{params[:author_id]}/post"
    end
  end
end
