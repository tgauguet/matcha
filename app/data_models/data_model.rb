module DataModel

  def self.init(data)
    data.each do |k,v|
      data[k] = data[k] ? Mysql.escape_string(Rack::Utils.escape_html(v)) : nil
    end
    data
  end

  def self.protect(new_data, old_data)
    new_data.each do |k,v|
      old_data[k] = v ? Mysql.escape_string(Rack::Utils.escape_html(v)) : old_data[k]
    end
    old_data
  end

end
