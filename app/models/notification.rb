require 'json'

class Notification < DBset

  def self.new(event_type, user_id, description)
    WsHelper.send_ws_message(user_id.to_s, {:type => event_type, :message => description}.to_json);
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
      DBset.server.query("UPDATE Notification SET is_read='1' WHERE id='#{id}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all_message(id)
    begin
      DBset.server.query("SELECT * FROM Notification WHERE (user_id='#{id}' AND event_type='message' AND is_read='0')")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.unread(id)
    begin
      DBset.server.query("SELECT * FROM Notification WHERE (user_id='#{id}' AND is_read='0')")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      DBset.server.query("SELECT * FROM Notification WHERE user_id='#{id}' ORDER BY ID DESC")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
