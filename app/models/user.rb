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
    # re-check how to create a proper array of data to insert in database
    # secure user's password
    args = UserData.init(args)
    $server.query("INSERT INTO User (name, firstname, email, login, password)
                  VALUES ('#{args['name']}', '#{args['firstname']}', '#{args['email']}', '#{args['login']}', '#{args['password']}')")
    id = $server.query("SELECT LAST_INSERT_ID();").fetch_hash
    self.find_by("id", id['LAST_INSERT_ID()'])
  end

  def self.update(args, id)
    args = UserData.init(args)
  end

  def self.delete(value)
  end

end
