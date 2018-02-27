require 'mysql2'
require 'yaml'
require './db/lib/init_db.rb'

set = YAML.load_file(__dir__ + '/database.yml')
set = set['development']

begin
  $server = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :encoding => 'utf8')
  $server.query('use matcha')
  if $server.query("SHOW TABLES LIKE 'User';").count == 0
    InitDb.init_database
  end
  if $server.query("SELECT * FROM User").count == 0
    InitDb.create_seeds
  end
rescue Mysql2::Error => e
  puts "ERROR #{e.errno} : #{e.error}"
  puts "Can't connect to the MySQL database specified."
end
