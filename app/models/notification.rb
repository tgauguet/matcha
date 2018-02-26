class Notification

  def self.new(event_type, user_id, description)
    begin
      $server.query("INSERT INTO Notification (event_type, user_id, description)
                    VALUES ('#{event_type}', '#{user_id}', '#{description}')")
      $server.query("SELECT LAST_INSERT_ID();").fetch_hash["LAST_INSERT_ID()"]
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.mark_as_read(id)
    begin
      $server.query("UPDATE Notification SET is_read='#{1}' WHERE id='#{id}'")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all_message(id)
    begin
      $server.query("SELECT * FROM Notification WHERE (user_id='#{id}' AND event_type='message' AND is_read='0')")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.unread(id)
    begin
      $server.query("SELECT * FROM Notification WHERE (user_id='#{id}' AND is_read='0')")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      $server.query("SELECT * FROM Notification WHERE user_id='#{id}'")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

end
