class UserConversation < DBset

  def self.new(id, conversation_id)
    begin
      state = DBset.server.prepare("INSERT INTO User_conversation (user_id, conversation_id) VALUES (?, ?)")
      state.execute(id, conversation_id)
      DBset.server.query("SELECT LAST_INSERT_ID();").first['LAST_INSERT_ID()']
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      state = DBset.server.prepare("SELECT * FROM User_conversation WHERE user_id= ?")
      res = state.execute(id)
      res ? res : nil
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.find_interlocutor(user_id, conversation_id)
    begin
      state = DBset.server.prepare("SELECT user_id FROM User_conversation WHERE (conversation_id= ? AND user_id NOT LIKE ?)")
      id = state.execute(conversation_id, user_id).first.to_dot.user_id
      return id ? id : nil
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.find_all(user_id, conversation_id)
    begin
      state = DBset.server.prepare("SELECT id FROM User_conversation WHERE onversation_id= ?")
      state.execute(conversation_id).all
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(id)
    begin
      state = DBset.server.prepare("DELETE FROM User_conversation WHERE id= ?")
      state.execute(id)
      return !self.exists?(id).nil?
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.not_exists?(id1, id2)
    begin
      state = DBset.server.prepare("SELECT conversation_id FROM User_conversation WHERE (user_id= ? OR user_id= ?)")
      res = state.execute(id1, id2)
      a = []
      res.each { |r| a << r.to_dot.conversation_id }
      a.uniq == a
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
