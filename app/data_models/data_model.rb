module DataModel

  def self.init(data)
    data.each do |k,v|
      data[k] = data[k] ? Sanitize.clean(v.to_s.force_encoding("UTF-8")) : nil
    end
    data
  end

  def self.protect(new_data, old_data)
    new_data.each do |k,v|
      old_data[k] = v ? Sanitize.clean(v.to_s.force_encoding("UTF-8")) : old_data[k]
    end
    old_data
  end

  def self.protect_arg(uniq)
    uniq = uniq ? Sanitize.clean(uniq.to_s.force_encoding("UTF-8")) : nil
  end

  def self.clean(data)
    data = DataModel.init(data)
    data['interested_in'] = data['interested_in'] ? data['interested_in'] : "B"
    data
  end

  def self.generate_suggestions(data)
    data = DataModel.init(data)
    user = User.find_by("id", data['id'])
    data['user_min_score'] = (user.public_score.to_i - 5).to_s
    data['user_max_score'] = (user.public_score.to_i + 5).to_s
    data['user_min_age'] = (user.age.to_i - 5).to_s
    data['user_max_age'] = (user.age.to_i + 5).to_s
    data
  end

end
