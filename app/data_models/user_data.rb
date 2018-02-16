class UserData

  attr_reader :id, :name, :firstname, :email, :login, :password, :password_token,
    :gender, :interested_in, :description, :img1, :img2, :img3, :img4, :img5,
    :public_score, :latitude, :longitude, :city, :age, :fake_account, :created_at

  def self.init(data)
    @id = data['id'] ? Integer(data['id']) : nil
    @name = data['name'] ? data['name'].to_s : nil
    @firstname = data['firstname'] ? data['firstname'].to_s : nil
    @email = data['email'] ? data['email'].to_s : nil
    @login = data['login'] ? data['login'].to_s : nil
    @password = data['password'] ? data['password'].to_s : nil
    @password_token = data['password_token'] ? data['password_token'].to_s : nil
    @gender = data['gender'] ? Integer(data['gender']) : nil
    @interested_in = data['interested_in'] ? Integer(data['interested_in']) : nil
    @description = data['description'] ? data['description'].to_s : nil
    @img1 = data['img1'] ? data['img1'].to_s : nil
    @img2 = data['img2'] ? data['img2'].to_s : nil
    @img3 = data['img3'] ? data['img3'].to_s : nil
    @img4 = data['img4'] ? data['img4'].to_s : nil
    @img5 = data['img5'] ? data['img5'].to_s : nil
    @public_score = data['public_score'] ? Integer(data['public_score']) : nil
    @latitude = data['latitude'] ? data['latitude'].to_f : nil
    @longitude = data['longitude'] ? data['longitude'].to_f : nil
    @age = data['age'] ? Integer(data['age']) : nil
    @fake_account = data['fake_account'] ? Integer(data['fake_account']) : nil
    @city = data['city'] ? data['city'].to_s : nil
    @created_at = data['created_at'] ? data['created_at'].to_s : nil
  end

end
