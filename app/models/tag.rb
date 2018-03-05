class Tag < DBset

  def self.all
    begin
      DBset.server.query("SELECT * FROM Tag")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.exists?(content)
    begin
      DBset.server.query("SELECT id FROM Tag WHERE content='#{content}'").first
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.find_by_id(id)
    begin
      if !id.nil?
         tagging = DBset.server.query("SELECT content FROM Tag WHERE id='#{id}'").first
         return tagging ? tagging.to_dot : nil
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.new(content)
    begin
      content = DataModel.protect_arg(content)
      state = DBset.server.prepare("INSERT INTO Tag (content) VALUES (?)")
      state.execute(content)
      tag = DBset.server.query("SELECT LAST_INSERT_ID();").first
      tag ? tag['LAST_INSERT_ID()'] : nil
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
