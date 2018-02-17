module UserData

  def self.init(data)
    data['name'] = data['name'] ? data['name'].to_s : nil
    data['firstname'] = data['firstname'] ? data['firstname'].to_s : nil
    data['email'] = data['email'] ? data['email'].to_s : nil
    data['login'] = data['login'] ? data['login'].to_s : nil
    data['password'] = data['password'] ? data['password'].to_s : nil
    data['password_token'] = data['password_token'] ? data['password_token'].to_s : nil
    data['gender'] = data['gender'] ? Integer(data['gender']) : nil
    data['interested_in'] = data['interested_in'] ? Integer(data['interested_in']) : nil
    data['description'] = data['description'] ? data['description'].to_s : nil
    data['img1'] = data['img1'] ? data['img1'].to_s : nil
    data['img2'] = data['img2'] ? data['img2'].to_s : nil
    data['img3'] = data['img3'] ? data['img3'].to_s : nil
    data['img4'] = data['img4'] ? data['img4'].to_s : nil
    data['img5'] = data['img5'] ? data['img5'].to_s : nil
    data['public_score'] = data['public_score'] ? Integer(data['public_score']) : nil
    data['latitude'] = data['latitude'] ? data['latitude'].to_f : nil
    data['longitude'] = data['longitude'] ? data['longitude'].to_f : nil
    data['age'] = data['age'] ? Integer(data['age']) : nil
    data['fake_account'] = data['fake_account'] ? Integer(data['fake_account']) : nil
    data['city'] = data['city'] ? data['city'].to_s : nil
    data['created_at'] = data['created_at'] ? data['created_at'].to_s : nil
    data
  end

end
