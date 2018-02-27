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

end
