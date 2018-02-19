class String

  def encrypt(salt)
    BCrypt::Engine.hash_secret(self, salt)
  end

  def check_password(salt, hash)
    self.encrypt(salt) == hash
  end

  def valid_float?
    true if Float self rescue false
  end

end
