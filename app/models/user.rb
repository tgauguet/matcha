class User
	# validates :email, presence: true, format: /\w+@\w+\.{1}[a-zA-Z]{2,}/, uniqueness: true
	# validates :login, presence: true, uniqueness: true
	# validates :password, presence: true, on: [:create]
	# validates :name, presence: true
	# validates :firstname, presence: true
	# validates_confirmation_of :password
	# has_secure_password
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

  def set_values(data)
    user = UserData.init(data)
    puts user
  end

  # √
  def self.all
    $server.query("SELECT * FROM User")
  end

  # √
  def self.find_by(type, value)
    (!type.nil? && !value.nil?) ? $server.query("SELECT * FROM User WHERE #{type} = #{value}").fetch_hash : nil
  end

  def self.new(args)
    args = set_values(args)
    $server.query("INSERT INTO User (name, firstname, email, login, password, password_token, gender, interested_in)
                  VALUES ()")
  end

  def self.update(args)
  end

  def self.delete(value)
  end

end
