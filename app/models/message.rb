class Message < DBset

  def self.new(content, user_id, conversation_id)
    begin
      content = DataModel.protect_arg(content)
      state = DBset.server.prepare("INSERT INTO Message (content, user_id, conversation_id)
                    VALUES (?, ?, ?)")
      state.execute(content, user_id, conversation_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      DBset.server.query("SELECT * FROM Message WHERE conversation_id='#{id}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
