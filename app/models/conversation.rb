class Conversation

  def self.find(id)
    begin
      $server.query("SELECT * FROM Conversation WHERE id='#{id}'").first
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.new(id1, id2)
    begin
      $server.query("INSERT INTO Conversation VALUES ()")
      conversation_id = $server.query("SELECT LAST_INSERT_ID();").first['LAST_INSERT_ID()']
      UserConversation.new(id1, conversation_id)
      UserConversation.new(id2, conversation_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(id)
    $server.query("DELETE FROM Conversation WHERE id='#{id}'")
    return !self.exists?(id).nil?
  end

end
