# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'

FILEPATH = 'public/memos.json'

def load_memos(filepath)
  File.open(filepath) { |f| JSON.parse(f.read) }
end

def update_memos(filepath, memos)
  File.open(filepath, 'w') { |f| JSON.dump(memos, f) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos(FILEPATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  memos = load_memos(FILEPATH)
  next_id = memos.empty? ? '1' : (memos.keys[-1].to_i + 1).to_s
  memos[next_id] = { 'title' => title, 'content' => content }
  update_memos(FILEPATH, memos)

  redirect '/memos'
end

get '/memos/:id' do
  memos = load_memos(FILEPATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :detail
end

get '/memos/:id/edit' do
  memos = load_memos(FILEPATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]

  memos = load_memos(FILEPATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  update_memos(FILEPATH, memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = load_memos(FILEPATH)
  memos.delete(params[:id])
  update_memos(FILEPATH, memos)

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
