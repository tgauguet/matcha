class ApplicationController < Sinatra::Base
	helpers ApplicationHelper
	register Sinatra::StrongParams
	$:.unshift(File.expand_path('../../lib', __FILE__))

	before '/*' do
		location
	end

	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") }
	set :public_folder, Proc.new { File.join(root, "public") }
	not_found{ slim :not_found }

	def current_user
		# current_user = User.find_by("id", id: session[:current_user_id])
		nil
	end

	def signed_in?
		# if session[:current_user_id]
			# if current_user #User.find_by(id: session[:current_user_id])
			# 	TRUE
			# else
			# 	FALSE
			# end
		# end
		FALSE
	end

end
