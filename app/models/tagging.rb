class Tagging

  def self.find_by_id(id)
    if !id.nil?
       tagging = $server.query("SELECT * FROM Tagging WHERE id='#{id}'").fetch_hash
       return tagging ? tagging.to_dot : nil
    end
  end

  def self.exists?(user_id, tag_id)
    begin
      $server.query("SELECT id FROM Tagging WHERE (user_id='#{user_id}' AND tag_id='#{tag_id}')").num_rows
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.new(user_id, tag_id)
    begin
      $server.query("INSERT INTO Tagging (user_id, tag_id) VALUES ('#{user_id}', '#{tag_id}')")
      $server.query("SELECT LAST_INSERT_ID();").fetch_hash
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      $server.query("SELECT * FROM Tagging WHERE user_id='#{id}'")
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(id)
    if id.to_i.to_s == id
      begin
        $server.query("DELETE Tagging WHERE id='#{id}'")
        return self.find_by_id(id).nil?
      rescue Mysql::Error => e
        puts e.errno
        puts e.error
      end
    end
    false
  end

end
