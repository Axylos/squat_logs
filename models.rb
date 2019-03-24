require 'pg'
require 'active_record'

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  host: 'kunai',
  user: 'postgres',
  database: 'squat_db'
})

class Request < ActiveRecord::Base
end
