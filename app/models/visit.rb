class Visit

  def self.new(args)
    begin
      args = DataModel.init(args)
      $server.query("INSERT INTO Visit (user_id, sender_id)
                    VALUES ('#{args['user_id']}', '#{args['sender_id']}')")
      id = $server.query("SELECT LAST_INSERT_ID();").fetch_hash
      self.find_by("id", id['LAST_INSERT_ID()'])
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

end
