class UserConversation

  def self.new(id, conversation_id)
    begin
      $server.query("INSERT INTO User_conversation
        (user_id, conversation_id) VALUES ('#{id}', '#{conversation_id}')")
      $server.query("SELECT LAST_INSERT_ID();").first['LAST_INSERT_ID()']
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      res = $server.query("SELECT * FROM User_conversation WHERE user_id='#{id}'")
      res ? res : nil
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.find_interlocutor(user_id, conversation_id)
    id = $server.query("SELECT user_id FROM User_conversation WHERE (conversation_id='#{conversation_id}' AND user_id NOT LIKE '#{user_id}')").first.to_dot.user_id
    return id ? id : nil
  end

  def self.find_all(user_id, conversation_id)
    $server.query("SELECT id FROM User_conversation WHERE onversation_id='#{conversation_id}'").all
  end

  def self.delete(id)
    $server.query("DELETE FROM User_conversation WHERE id='#{id}'")
    return !self.exists?(id).nil?
  end

end
