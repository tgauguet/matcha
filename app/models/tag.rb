class Tag

  def self.all
    $server.query("SELECT * FROM Tag")
  end

  def self.exists?(content)
    begin
      $server.query("SELECT id FROM Tag WHERE content='#{content}'").first
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.find_by_id(id)
    if !id.nil?
       tagging = $server.query("SELECT content FROM Tag WHERE id='#{id}'").first
       return tagging ? tagging.to_dot : nil
    end
  end

  def self.new(content)
    begin
      content = DataModel.protect_arg(content)
      $server.query("INSERT INTO Tag (content) VALUES ('#{content}')")
      tag = $server.query("SELECT LAST_INSERT_ID();").first
      tag ? tag['LAST_INSERT_ID()'] : nil
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

end
