class Message < DBset

  def self.new(content, user_id, conversation_id)
    begin
      content = DataModel.protect_arg(content)
      unless content.blank?
        state = DBset.server.prepare("INSERT INTO Message (content, user_id, conversation_id) VALUES (?, ?, ?)")
        state.execute(content, user_id, conversation_id)
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      state = DBset.server.prepare("SELECT * FROM Message WHERE conversation_id= ? ORDER BY created_at DESC")
      state.execute(id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
