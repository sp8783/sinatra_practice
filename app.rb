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
  add_memo(params.slice(:title, :content))
  redirect '/memos'
end

get '/memos/:id' do
  @memo = load_memo_by_id(params[:id])
  erb :detail
end

get '/memos/:id/edit' do
  @memo = load_memo_by_id(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo = params.slice(:title, :content, :id)
  update_memo(memo)
  redirect "/memos/#{memo[:id]}"
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
