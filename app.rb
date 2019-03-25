require 'sinatra'
require 'whois'
require 'whois-parser'
require 'haml'
require 'sinatra/reloader' if development?
require "pg"
require "active_record"
require './models'


ActiveRecord::Base.establish_connection("postgres://postgres@192.168.1.176/squat_db")
set :port, 8080 unless development?
set :domain, 'http://draketalley.com/squat_logs'
require './models'
whois = Whois::Client.new

def format_time(time)
  t = time.to_datetime
  t = t - 4.hours
  t.strftime("%b %d %Y:  %I:%M %p")
end

after do
  ActiveRecord::Base.clear_active_connections!
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
