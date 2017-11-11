$:.unshift(File.expand_path('../../lib', __FILE__))

class ApplicationController < Sinatra::Base
	#helpers ApplicationHelpers
	register Sinatra::StrongParams
	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") }
	set :public_folder, Proc.new { File.join(root, "public") }
	after do
	  ActiveRecord::Base.connection.close
	end
	not_found{ slim :not_found }

	def current_user
		current_user = User.find_by(id: session[:current_user_id])
	end

	def signed_in?
		if User.find_by(id: session[:current_user_id])
			TRUE
		else
			FALSE
		end
	end
end
