require 'mysql'
require 'yaml'
require './db/lib/init_db.rb'

set = YAML.load_file(__dir__ + '/database.yml')
set = set['development']

begin
  $server = Mysql.new(set['host'], set['user'], set['password'], set['db_name'])
  $server.query('use matcha')
  # create tables if don't exists
  if ($server.query("SHOW TABLES LIKE 'User';").num_rows == 0)
    InitDb.init_database
  end
  # create fake users if don't exists
  if ($server.query("SELECT * FROM User").num_rows == 0)
    InitDb.create_seeds
  end
rescue Exception => e
  logger.debug "#{e.class}"
end
