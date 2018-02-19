module ApplicationHelper

  def location
	  page = "http://freegeoip.net/json/"
	  doc = Nokogiri::HTML(open(page, 'User-Agent' => 'ruby'))
		doc = JSON.parse(doc)
	  @lat = doc["latitude"]
		@lon = doc["longitude"]
	end

  def this_page?(val)
    request.path.gsub!("/", "") == val
  end

  def get_image(img)
    current_user[img] ? current_user[img] : 'empty.png'
  end

end
