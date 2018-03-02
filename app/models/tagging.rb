class Tagging

  def self.find_by_id(id)
    if !id.nil?
       tagging = $server.query("SELECT * FROM Tagging WHERE id='#{id}'").first
       return tagging ? tagging.to_dot : nil
    end
  end

  def self.exists?(user_id, tag_id)
    begin
      $server.query("SELECT id FROM Tagging WHERE (user_id='#{user_id}' AND tag_id='#{tag_id}')").count
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.matchs(id, interlocutor)
    $server.query("SELECT content FROM Tag WHERE (id IN (SELECT tag_id FROM Tagging WHERE (tag_id IN (SELECT tag_id FROM Tagging WHERE(user_id='#{id}')) AND user_id='#{interlocutor}')))")
  end

  def self.selection_match(id, interlocutor, ids_list)
    $server.query("SELECT content FROM Tag WHERE (id IN (SELECT tag_id FROM Tagging WHERE (tag_id IN (SELECT tag_id FROM Tagging WHERE (user_id='#{id}' AND tag_id IN (SELECT id FROM Tag WHERE id IN (#{ids_list.join(', ')})))) AND user_id='#{interlocutor}')))")
  end

  def self.new(user_id, tag_id)
    begin
      $server.query("INSERT INTO Tagging (user_id, tag_id) VALUES ('#{user_id}', '#{tag_id}')")
      $server.query("SELECT LAST_INSERT_ID();").first
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(id)
    begin
      $server.query("SELECT * FROM Tagging WHERE user_id='#{id}'")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(id)
    if id.to_i.to_s == id
      begin
        $server.query("DELETE Tagging WHERE id='#{id}'")
        return self.find_by_id(id).nil?
      rescue Mysql2::Error => e
        puts e.errno
        puts e.error
      end
    end
    false
  end

end
