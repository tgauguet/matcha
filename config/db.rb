require 'mysql'
require 'yaml'
require './db/lib/init_db.rb'

set = YAML.load_file(__dir__ + '/database.yml')
set = set['development']

begin
  $server = Mysql.new(set['host'], set['user'], set['password'], set['db_name'])
  $server.query('use matcha')
  if ($server.query("SHOW TABLES LIKE 'User';").num_rows == 0)
    InitDb.init_database
  end
  if ($server.query("SELECT * FROM User").num_rows == 0)
    InitDb.create_seeds
  end
rescue Mysql::Error => e
  puts "ERROR #{e.errno} (#{e.sqlstate}): #{e.error}"
  puts "Can't connect to the MySQL database specified."
end
