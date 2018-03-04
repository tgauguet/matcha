module DataModel

  def self.init(data)
    data.each do |k,v|
      DataModel.protect_arg(v)
    end
    data
  end

  def self.protect_arg(value)
    value = value ? Sanitize.clean(value.to_s.force_encoding("UTF-8")) : nil
  end

  def self.clean(data)
    data = DataModel.init(data)
    data['gender'] = data['gender'] ? data['gender'] : "B"
    data
  end

  def self.get_suggestions(data)
    data = DataModel.init(data)
    user = User.find_by("id", data['id'])
    data['user_min_score'] = (user.public_score.to_i - 5).to_s
    data['user_max_score'] = (user.public_score.to_i + 5).to_s
    data['user_min_age'] = (user.age.to_i - 5).to_s
    data['user_max_age'] = (user.age.to_i + 5).to_s
    data
  end

end
