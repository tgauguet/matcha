class Liked < DBset

  def self.new(args)
    begin
      args = DataModel.init(args)
      state = DBset.server.prepare("INSERT INTO Liked (user_id, sender_id) VALUES (?, ?)")
      state.execute(args['user_id'], args['sender_id'])
      DBset.server.query("SELECT LAST_INSERT_ID();").first.to_dot
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.liked?(user_id, sender_id)
    begin
      state = DBset.server.prepare("SELECT id FROM Liked WHERE (user_id= ? AND sender_id= ?)")
      state.execute(user_id, sender_id).count
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(value)
    begin
      state = DBset.server.prepare("SELECT sender_id FROM Liked WHERE user_id = ?")
      state.execute(value)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(args)
    begin
      state = DBset.server.prepare("DELETE FROM Liked WHERE (user_id = ? AND sender_id = ?)")
      state.execute(args['user_id'], args['sender_id'])
      return !self.liked?(args['user_id'], args['sender_id']).nil?
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
