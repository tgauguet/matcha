class ApplicationController < Sinatra::Base
	helpers ApplicationHelper
	register Sinatra::StrongParams
	$:.unshift(File.expand_path('../../lib', __FILE__))
	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") }
	set :public_folder, Proc.new { File.join(root, "public") }

	before '/*' do
		location
	end

	get '/not-found' do
		erb :'errors/not_found'
	end

	def update_public_score(id, value)
		current = User.find_by("id", id)["public_score"]
		new_val = current.to_i + value
		User.update_score(id, new_val) unless (new_val < 1 || new_val > 99)
	end

	def current_user
		# to be removed
		current_user = User.find_by("id", 2)
		# if session[:current_user_id]
		# 	current_user = User.find_by("id", session[:current_user_id])
		# end
	end

	def message_count
		res = Notification.all_message(current_user.id)
		res.count == 0 ? "" : "<span class='counter'>" + res.count.to_s + "</span>"
	end

	def notification_count
		res = Notification.unread(current_user.id)
		res.count == 0 ? "" : "<span class='counter'>" + res.count.to_s + "</span>"
	end

	def signed_in?
		!current_user.nil?
	end

	def authenticate
		@user = current_user
		redirect '/' unless @user
	end

end
