require 'pony'

set = YAML.load_file(__dir__ + '/secrets.yml')
set = set['development']

Mail.defaults do
  delivery_method :smtp,
  address: set['address'],
  port: set['port'],
  user_name: set['user_name'],
  password: set['password'],
  authentication: set['authentication']
end
