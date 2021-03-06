require "./app/lib/encrypt.rb"
module InitDb

  def self.init_database(server)
    server.query("CREATE TABLE IF NOT EXISTS User (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  name VARCHAR(256) NOT NULL,
                  firstname VARCHAR(256) NOT NULL,
                  email VARCHAR(256) NOT NULL,
                  login VARCHAR(256) NOT NULL,
                  password VARCHAR(256) NOT NULL,
                  password_token VARCHAR(256),
                  websocket_token VARCHAR(256),
                  gender VARCHAR(256),
                  interested_in VARCHAR(256),
                  description TEXT,
                  salt VARCHAR(256),
                  img1 VARCHAR(256),
                  img2 VARCHAR(256),
                  img3 VARCHAR(256),
                  img4 VARCHAR(256),
                  img5 VARCHAR(256),
                  public_score INT(3) DEFAULT 1,
                  latitude FLOAT,
                  longitude FLOAT,
                  reported_as_fake INT(3),
                  city VARCHAR(256),
                  age INT(6),
                  last_login DATETIME DEFAULT CURRENT_TIMESTAMP,
                  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table User was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Visit (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  sender_id INT(6) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Visit was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Tag (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  content VARCHAR(256) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Tag was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Tagging (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  tag_id INT(6) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Tagging was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Notification (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  event_type VARCHAR(256) NOT NULL,
                  description VARCHAR(256) NOT NULL,
                  is_read INT(2) DEFAULT 0,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Notification was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Message (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  content TEXT,
                  conversation_id INT(6) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Message was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Liked (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  sender_id INT(6) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Liked was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Conversation (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Conversation was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS User_conversation(
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  conversation_id INT(6) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table UserConversation was successfull created"
    server.query("CREATE TABLE IF NOT EXISTS Block (
                  id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                  user_id INT(6) NOT NULL,
                  sender_id INT(6) NOT NULL,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                  )")
    puts "Table Block was successfull created"
  end

  def self.create_seeds(server)
    file = JSON.parse(File.read('./db/seeds/seeds.json'))
    fi = file.first
    salt = BCrypt::Engine.generate_salt
    file.each_with_index do |seed, index|
      print "CREATE SEEDS USER : #{index}/600 \r"
      seed['password'] = seed['password'].encrypt(salt)
      state = server.prepare("INSERT INTO User (name, firstname, email, login, password, gender, interested_in, age, img1, city, latitude, longitude, public_score, description, salt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
      state.execute(seed['name'], seed['firstname'], seed['email'], seed['login'], seed['password'], seed['gender'], seed['interested_in'], seed['age'], seed['img1'], seed['city'], seed['latitude'], seed['longitude'], seed['public_score'], seed['description'], salt)
    end
  end

end
