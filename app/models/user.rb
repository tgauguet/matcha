class User < DBset

  def self.all(id)
    begin
      DBset.server.query("SELECT * FROM User WHERE (id <> '#{id}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{id}'))").to_a
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all_according_to(args)
    begin
      args = DataModel.clean(args)
      if args['gender'] == "B"
        DBset.server.query("SELECT * FROM User WHERE (id <> '#{args['id']}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{args['id']}') AND (age BETWEEN '#{args['min_age']}' AND '#{args['max_age']}') AND (public_score BETWEEN '#{args['min_score']}' AND '#{args['max_score']}'))").to_a
      else
        DBset.server.query("SELECT * FROM User WHERE (id <> '#{args['id']}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{args['id']}') AND (age BETWEEN '#{args['min_age']}' AND '#{args['max_age']}') AND (public_score BETWEEN '#{args['min_score']}' AND '#{args['max_score']}') AND gender='#{args['gender']}')").to_a
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
      if args['gender'] == "B"
        if args['interested_in'] == "B"
          DBset.server.query("SELECT * FROM User WHERE (((age BETWEEN '#{args['user_min_age']}' AND  '#{args['user_max_age']}') OR (public_score BETWEEN '#{args['user_min_score']}' AND '#{args['user_max_score']}')) AND id IN (SELECT id FROM User WHERE (id <> '#{args['id']}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{args['id']}') AND (age BETWEEN '#{args['min_age']}' AND '#{args['max_age']}') AND (public_score BETWEEN '#{args['min_score']}' AND '#{args['max_score']}'))))")
        else
          DBset.server.query("SELECT * FROM User WHERE (((age BETWEEN '#{args['user_min_age']}' AND  '#{args['user_max_age']}') OR (public_score BETWEEN '#{args['user_min_score']}' AND '#{args['user_max_score']}') OR gender='#{args['interested_in']}') AND id IN (SELECT id FROM User WHERE (id <> '#{args['id']}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{args['id']}') AND (age BETWEEN '#{args['min_age']}' AND '#{args['max_age']}') AND (public_score BETWEEN '#{args['min_score']}' AND '#{args['max_score']}'))))")
        end
      else
        if args['interested_in'] == "B"
          DBset.server.query("SELECT * FROM User WHERE (((age BETWEEN '#{args['user_min_age']}' AND '#{args['user_max_age']}') OR (public_score BETWEEN '#{args['user_min_score']}' AND '#{args['user_max_score']}')) AND id IN(SELECT id FROM User WHERE (id <> '#{args['id']}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{args['id']}') AND (age BETWEEN '#{args['min_age']}' AND '#{args['max_age']}') AND (public_score BETWEEN '#{args['min_score']}' AND '#{args['max_score']}') AND gender='#{args['gender']}')))")
        else
          DBset.server.query("SELECT * FROM User WHERE (((age BETWEEN '#{args['user_min_age']}' AND '#{args['user_max_age']}') OR (public_score BETWEEN '#{args['user_min_score']}' AND '#{args['user_max_score']}') OR gender='#{args['interested_in']}') AND id IN(SELECT id FROM User WHERE (id <> '#{args['id']}' AND id NOT IN (SELECT user_id FROM Block WHERE sender_id='#{args['id']}') AND (age BETWEEN '#{args['min_age']}' AND '#{args['max_age']}') AND (public_score BETWEEN '#{args['min_score']}' AND '#{args['max_score']}') AND gender='#{args['gender']}')))")
        end
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
      state = DBset.server.prepare("INSERT INTO User (name, firstname, email, login, password, salt, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")
      state.execute(args['name'], args['firstname'], args['email'], args['login'], password, salt, args['latitude'], args['longitude'])
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
        unless v.empty?
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
      DBset.server.query("UPDATE User SET public_score='#{score}' WHERE id='#{user_id}'") unless score.empty?
      self.find_by("id", user_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(value)
    begin
      if value.to_i.to_s == value
        DBset.server.query("DELETE FROM User WHERE id = '#{value}'")
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
      DBset.server.query("UPDATE User SET last_login=NOW() WHERE id='#{id}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.between(min, max)
    begin
      DBset.server.query("SELECT * FROM User WHERE id BETWEEN '#{min}' AND '#{max}'")
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
