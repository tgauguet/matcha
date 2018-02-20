class ApplicationController < Sinatra::Base
	helpers ApplicationHelper
	register Sinatra::StrongParams
	$:.unshift(File.expand_path('../../lib', __FILE__))
	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") }
	set :public_folder, Proc.new { File.join(root, "public") }
	not_found{ slim :not_found }

	before '/*' do
		location
	end

	def current_user
		# to be removed
		current_user = User.find_by("id", 601)
		# if session[:current_user_id]
		# 	current_user = User.find_by("id", session[:current_user_id])
		# end
	end

	def signed_in?
		!current_user.nil?
	end

end
