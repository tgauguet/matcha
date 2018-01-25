$:.unshift(File.expand_path('../../lib', __FILE__))

class ApplicationController < Sinatra::Base
	#helpers ApplicationHelpers
	register Sinatra::StrongParams

	before '/*' do
		location
	end

	after do
    ActiveRecord::Base.connection.close
	end

	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") }
	set :public_folder, Proc.new { File.join(root, "public") }
	not_found{ slim :not_found }

	def current_user
		# force user to always be User 1 and logged in
		# current_user = User.find_by(id: session[:current_user_id])
		current_user = User.find(6)
	end

	def signed_in?
		# if session[:current_user_id]
			if current_user #User.find_by(id: session[:current_user_id])
				TRUE
			else
				FALSE
			end
		# end
	end

	def location
	  page = "http://freegeoip.net/json/"
	  doc = Nokogiri::HTML(open(page, 'User-Agent' => 'ruby'))
		doc = JSON.parse(doc)
	  @lat = doc["latitude"]
		@lon = doc["longitude"]
	end

end
