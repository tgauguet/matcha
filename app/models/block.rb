class Block

  def self.new(args)
    begin
      args = DataModel.init(args)
      $server.query("INSERT INTO Block (user_id, sender_id)
                    VALUES ('#{args['user_id']}', '#{args['sender_id']}')")
      $server.query("SELECT LAST_INSERT_ID();").first.to_dot
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.blocked?(user_id, sender_id)
    begin
      $server.query("SELECT * FROM Block WHERE (user_id='#{user_id}' AND sender_id='#{sender_id}')").count
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(args)
    $server.query("DELETE FROM Block WHERE (user_id = '#{args['user_id']}' AND sender_id = '#{args['sender_id']}')")
    return !self.blocked?(args['user_id'], args['sender_id']).nil?
  end

end
