class Notification < DBset

  def self.new(event_type, user_id, description)
    begin
      state = DBset.server.prepare("INSERT INTO Notification (event_type, user_id, description) VALUES (? ,?, ?)")
      state.execute(event_type, user_id, description)
      DBset.server.query("SELECT LAST_INSERT_ID();").first.to_dot
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.mark_as_read(id)
    begin
      state = DBset.server.prepare("UPDATE Notification SET is_read='1' WHERE id= ?")
      state.execute(id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all_message(id)
    begin
      state = DBset.server.prepare("SELECT * FROM Notification WHERE (user_id= ? AND event_type='message' AND is_read='0')")
      state.execute(id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.unread(id)
    begin
      state = DBset.server.prepare("SELECT * FROM Notification WHERE (user_id= ? AND is_read='0')")
      state.execute(id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      state = DBset.server.prepare("SELECT * FROM Notification WHERE user_id= ?")
      state.execute(id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
