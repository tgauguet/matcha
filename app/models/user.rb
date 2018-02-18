require './app/data_models/user_data.rb'

class User
	# has_many :tags
	# has_many :taggings, through: :tags
  #
	# def all_tags=(names)
	# 	self.taggings = names.split(",").map do |name|
	# 		Tagging.where(name: name.strip).first_or_create!
	# 	end
	# end
  #
	# def all_tags
	# 	self.tags.map(&:name).join(", ")
	# end

  def self.all
    $server.query("SELECT * FROM User")
  end

  def self.find_by(type, value)
    (!type.nil? && !value.nil?) ? $server.query("SELECT * FROM User WHERE #{type} = #{value}").fetch_hash : nil
  end

  def self.new(args)
    begin
      password = args['password'].encrypt
      args = UserData.init(args)
      $server.query("INSERT INTO User (name, firstname, email, login, password)
                    VALUES ('#{args['name']}', '#{args['firstname']}', '#{args['email']}', '#{args['login']}', '#{password}')")
      id = $server.query("SELECT LAST_INSERT_ID();").fetch_hash
      self.find_by("id", id['LAST_INSERT_ID()'])
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.update(params, args)
    begin
      params = UserData.init(params)
      params.each do |k,v|
        $server.query("UPDATE User SET #{k} = '#{v}' WHERE id = '#{args['id']}'")
      end
      self.find_by("id", args['id'])
    rescue Mysql::Error => e
      puts e.errno
      puts e.error
    end
  end

  def self.delete(value)
    if value.to_i.to_s == value
      $server.query("DELETE FROM User WHERE id = '#{value}'")
      return self.find_by("id", value).nil?
    end
    false
  end

end
