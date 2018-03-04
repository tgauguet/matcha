class Visit < DBset

  def self.not_exists(id, sender_id)
    begin
      DBset.server.query("SELECT id FROM Visit WHERE (user_id='#{id}' AND sender_id='#{sender_id}')").count
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.new(user_id, sender_id)
    begin
      DBset.server.query("INSERT INTO Visit (user_id, sender_id)
                    VALUES ('#{user_id}', '#{sender_id}')")
      DBset.server.query("SELECT LAST_INSERT_ID();").first
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      DBset.server.query("SELECT * FROM Visit WHERE user_id='#{id}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end


end
