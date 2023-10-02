# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'db'

configure do
  create_table
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_all_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  add_memo(title, content)
  redirect '/memos'
end

get '/memos/:id' do
  @memo = load_the_memo_with_id(params[:id])
  erb :detail
end

get '/memos/:id/edit' do
  @memo = load_the_memo_with_id(params[:id])
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  id = params[:id]

  update_memo(title, content, id)
  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end

not_found do
  'This is nowhere to be found.'
end

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end
