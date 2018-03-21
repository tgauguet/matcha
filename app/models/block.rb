class Block < DBset

  def self.new(args)
    begin
      args = DataModel.init(args)
      state = DBset.server.prepare("INSERT INTO Block (user_id, sender_id) VALUES (?, ?)")
      state.execute(args['user_id'], args['sender_id'])
      DBset.server.query("SELECT LAST_INSERT_ID();").first.to_dot
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.blocked?(user_id, sender_id)
    begin
      state = DBset.server.prepare("SELECT * FROM Block WHERE (user_id= ? AND sender_id= ? )")
      state.execute(user_id, sender_id).count == 1
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(args)
    begin
      state = DBset.server.prepare("DELETE FROM Block WHERE (user_id = ? AND sender_id = ?)")
      state.execute(args['user_id'], args['sender_id'])
      return !self.blocked?(args['user_id'], args['sender_id']).nil?
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
