class Liked < DBset

  def self.new(args)
    begin
      args = DataModel.init(args)
      DBset.server.query("INSERT INTO Liked (user_id, sender_id)
                    VALUES ('#{args['user_id']}', '#{args['sender_id']}')")
      DBset.server.query("SELECT LAST_INSERT_ID();").first.to_dot
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.liked?(user_id, sender_id)
    begin
      DBset.server.query("SELECT id FROM Liked WHERE (user_id='#{user_id}' AND sender_id='#{sender_id}')").count
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(value)
    begin
      DBset.server.query("SELECT sender_id FROM Liked WHERE user_id = '#{value}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(args)
    begin
      DBset.server.query("DELETE FROM Liked WHERE (user_id = '#{args['user_id']}' AND sender_id = '#{args['sender_id']}')")
      return !self.liked?(args['user_id'], args['sender_id']).nil?
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
