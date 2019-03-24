require 'sinatra'
require 'byebug'
require 'whois'
require 'whois-parser'
require 'haml'
require 'sinatra/reloader' if development?

require './models'
whois = Whois::Client.new

def format_time(time)
  t = time.to_datetime
  t = t - 4.hours
  t.strftime("%b %d %Y:  %I:%M %p")
end

get '/' do
  haml :welcome, format: :html5
end
get '/index' do
  @reqs = Request.where(is_me: false).order(id: :desc).all
  haml :index, format: :html5
end

get '/raw-req/:id' do
  @req = Request.find(params[:id])
  @ip = @req.remote_addr
  @record = whois.lookup(@ip)
  haml :show, format: :html5
end
