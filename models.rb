require 'pg'
require 'active_record'

ActiveRecord::Base.establish_connection("postgres://postgres@192.168.1.176/squat_db")

class Request < ActiveRecord::Base
end
