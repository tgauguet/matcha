class Conversation < DBset

  def self.find(id)
    begin
      DBset.server.query("SELECT * FROM Conversation WHERE id='#{id}'").first
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.new(id1, id2)
    begin
      DBset.server.query("INSERT INTO Conversation VALUES ()")
      conversation_id = DBset.server.query("SELECT LAST_INSERT_ID();").first['LAST_INSERT_ID()']
      UserConversation.new(id1, conversation_id)
      UserConversation.new(id2, conversation_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(id)
    begin
      DBset.server.query("DELETE FROM Conversation WHERE id='#{id}'")
      return !self.exists?(id).nil?
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
