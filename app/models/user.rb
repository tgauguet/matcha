class User

  def self.all(id)
    $server.query("SELECT * FROM User WHERE NOT id='#{id}'").to_a
  end

  def self.find_by(type, value)
    if !type.nil? && !value.nil?
       user = $server.query("SELECT * FROM User WHERE #{type} = '#{value}'")
       return user ? user.first.to_dot : nil
    end
  end

  def self.new(args)
    begin
      salt = BCrypt::Engine.generate_salt
      password = args['password'].encrypt(salt)
      args = DataModel.init(args)
      $server.query("INSERT INTO User (name, firstname, email, login, password, salt, latitude, longitude)
                    VALUES ('#{args['name']}', '#{args['firstname']}', '#{args['email']}', '#{args['login']}', '#{password}', '#{salt}', '#{args['latitude']}', '#{args['longitude']}')")
      id = $server.query("SELECT LAST_INSERT_ID();")
      self.find_by("id", id['LAST_INSERT_ID()'])
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
        $server.query("UPDATE User SET #{k} = '#{v}' WHERE id = '#{args['id']}'") unless v.empty?
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
      $server.query("UPDATE User SET public_score='#{score}' WHERE id='#{user_id}'") unless score.empty?
      self.find_by("id", user_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(value)
    if value.to_i.to_s == value
      $server.query("DELETE FROM User WHERE id = '#{value}'")
      return self.find_by("id", value).nil?
    end
    false
  end

  def self.match(args)
    user = self.find_by("login", args["login"])
    return user && (args["password"].check_password(user['salt'], user['password'])) ? self.find_by("id", user['id']) : nil
  end

  def self.logged_in(id)
    begin
      $server.query("UPDATE User SET last_login=NOW() WHERE id='#{id}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.between(min, max)
    $server.query("SELECT * FROM User WHERE id BETWEEN '#{min}' AND '#{max}'")
  end

end
