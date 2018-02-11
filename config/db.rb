require 'mysql'
require 'yaml'

set = YAML.load_file(__dir__ + '/database.yml')
set = set['development']

begin
  server = Mysql.new(set['host'], set['user'], set['password'], set['db_name'])
  server.query('use matcha')
  # users = server.query('SELECT * FROM User')
rescue
  
end
