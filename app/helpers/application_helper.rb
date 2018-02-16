module ApplicationHelper

  def location
	  page = "http://freegeoip.net/json/"
	  doc = Nokogiri::HTML(open(page, 'User-Agent' => 'ruby'))
		doc = JSON.parse(doc)
	  @lat = doc["latitude"]
		@lon = doc["longitude"]
	end

end
