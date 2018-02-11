configure :development do
  set :database, {adapter: 'mysql', host: 'localhost', encoding: 'unicode', database: 'matcha', pool: 2}
end
