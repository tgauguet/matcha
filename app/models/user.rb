class User < ActiveRecord::Base
	# validates :email, presence: true, format: /\w+@\w+\.{1}[a-zA-Z]{2,}/
	# validates :login, presence: true, uniqueness: true
	# validates :password, presence: true, length: { :minimum => 8}
	# validates_confirmation_of :password
	# has_secure_password
end
