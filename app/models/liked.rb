class Liked

  def self.new(args)
    begin
      args = DataModel.init(args)
      $server.query("INSERT INTO Liked (user_id, sender_id)
                    VALUES ('#{args['user_id']}', '#{args['sender_id']}')")
      $server.query("SELECT LAST_INSERT_ID();").fetch_hash["LAST_INSERT_ID()"]
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.liked?(user_id, sender_id)
    begin
      $server.query("SELECT * FROM Liked WHERE (user_id='#{user_id}' AND sender_id='#{sender_id}')").num_rows
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.all(value)
    $server.query("SELECT sender_id FROM Liked WHERE user_id = '#{value}'")
  end

  def self.delete(args)
    $server.query("DELETE FROM Liked WHERE (user_id = '#{args['user_id']}' AND sender_id = '#{args['sender_id']}')")
    return !self.liked?(args['user_id'], args['sender_id']).nil?
  end

end
