class Message

  def self.new(content, user_id, conversation_id)
    begin
      content = DataModel.protect_arg(content)
      $server.query("INSERT INTO Message (content, user_id, conversation_id)
                    VALUES ('#{content}', '#{user_id}', '#{conversation_id}')")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      $server.query("SELECT * FROM Message WHERE conversation_id='#{id}'")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

end
