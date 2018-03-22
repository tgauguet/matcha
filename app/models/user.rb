class User < DBset

  def self.all(id)
    begin
      state = DBset.server.prepare("SELECT * FROM User WHERE (id <> ? AND id NOT IN (SELECT user_id FROM Block WHERE sender_id= ?))")
      state.execute(id, id).to_a
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all_according_to(args)
    begin
      args = DataModel.clean(args)
      if args['gender'] == "B"
        state = DBset.server.prepare("SELECT * FROM User WHERE (id <> ? AND id NOT IN (SELECT user_id FROM Block WHERE sender_id= ?) AND (age BETWEEN ? AND ?) AND (public_score BETWEEN ? AND ?))")
        state.execute(args['id'], args['id'], args['min_age'], args['max_age'], args['min_score'], args['max_score']).to_a
      else
        state = DBset.server.prepare("SELECT * FROM User WHERE (id <> ? AND id NOT IN (SELECT user_id FROM Block WHERE sender_id= ?) AND (age BETWEEN ? AND ?) AND (public_score BETWEEN ? AND ?) AND gender= ?)")
        state.execute(args['id'], args['id'], args['min_age'], args['max_age'], args['min_score'], args['max_score'], args['gender']).to_a
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.personalized(args)
    begin
      args = DataModel.clean(args)
      args = DataModel.get_suggestions(args)
      if args['interested_in'] == "B"
        puts "CHECK HERE 3"
        state = DBset.server.prepare("SELECT * FROM User WHERE (((age BETWEEN ? AND ?) OR (public_score BETWEEN ? AND ?)) AND id IN (SELECT id FROM User WHERE (id <> ? AND id NOT IN (SELECT user_id FROM Block WHERE sender_id= ?) AND (age BETWEEN ? AND ?) AND (public_score BETWEEN ? AND ?))))")
        state.execute(args['user_min_age'], args['user_max_age'], args['user_min_score'], args['user_max_score'], args['id'], args['id'], args['min_age'], args['max_age'], args['min_score'], args['max_score'])
      else
        puts "CHECK HERE 4"
        state = DBset.server.prepare("SELECT * FROM User WHERE (((age BETWEEN ? AND ?) OR (public_score BETWEEN ? AND ?) OR gender= ?) AND id IN (SELECT id FROM User WHERE (id <> ? AND id NOT IN (SELECT user_id FROM Block WHERE sender_id= ?) AND (age BETWEEN ? AND ?) AND (public_score BETWEEN ? AND ?))))")
        state.execute(args['user_min_age'], args['user_max_age'], args['user_min_score'], args['user_max_score'], args['interested_in'], args['id'], args['id'], args['min_age'], args['max_age'], args['min_score'], args['max_score'])
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.find_by(type, value)
    begin
      if !type.nil? && !value.nil?
        state = DBset.server.prepare("SELECT * FROM User WHERE #{type}= ?")
        user = state.execute(value).to_a
        return user.empty? ? nil : user.first.to_dot
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.new(args)
    begin
      salt = BCrypt::Engine.generate_salt
      password = args['password'].encrypt(salt)
      args = DataModel.init(args)
      args = DataModel.init_location_and_websocket_key(args)
      state = DBset.server.prepare("INSERT INTO User (name, firstname, email, login, password, salt, latitude, longitude, websocket_token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")
      state.execute(args['name'], args['firstname'], args['email'], args['login'], password, salt, args['latitude'], args['longitude'], args['websocket_token'])
      id = DBset.server.query("SELECT LAST_INSERT_ID();").first['LAST_INSERT_ID()']
      self.find_by("id", id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.update(params, args)
    begin
      if params['password']
        params['salt'] = BCrypt::Engine.generate_salt
        params['password'] = params['password'].encrypt(params['salt'])
      end
      params = DataModel.init(params)
      params.each do |k,v|
        unless v.nil?
          state = DBset.server.prepare("UPDATE User SET #{k} = ? WHERE id = ?")
          state.execute(v, args['id'])
        end
      end
      self.find_by("id", args['id'])
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.update_score(user_id, score)
    begin
      score = DataModel.protect_arg(score)
      unless score.empty?
        state = DBset.server.prepare("UPDATE User SET public_score= ? WHERE id= ?")
        state.execute(score, user_id)
      end
      self.find_by("id", user_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(value)
    begin
      if value.to_i.to_s == value
        state = DBset.server.prepare("DELETE FROM User WHERE id = ?")
        state.execute(value)
        return self.find_by("id", value).nil?
      end
      false
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.match(args)
    begin
      user = self.find_by("login", args["login"])
      return user && (args["password"].check_password(user['salt'], user['password'])) ? self.find_by("id", user['id']) : nil
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.logged_in(id)
    begin
      state = DBset.server.prepare("UPDATE User SET last_login=NOW() WHERE id= ?")
      state.execute(id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.between(min, max)
    begin
      state = DBset.server.prepare("SELECT * FROM User WHERE id BETWEEN ? AND ?")
      state.execute(min, max)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.complete?(id)
    begin
      DBset.server.query("SELECT id FROM User WHERE ( name AND firstname AND login AND email AND password AND latitude AND longitude AND img1 AND img2 AND img3 AND img4 AND img5 AND gender AND interested_in AND description AND city AND age IS NOT NULL)")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.validate_uniqueness_of(param, value)
    begin
      value = DataModel.protect_arg(value)
      state = DBset.server.prepare("SELECT * FROM User WHERE #{param} = ?")
      state.execute(value).count == 0 ? TRUE : FALSE
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
