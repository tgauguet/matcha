class String

  def encrypt
    salt = BCrypt::Engine.generate_salt
    BCrypt::Engine.hash_secret(self, salt)
  end

  def verify_password(compare)
    self.encrypt == compare
  end

end
