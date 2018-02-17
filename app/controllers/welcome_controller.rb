class WelcomeController < ApplicationController

	get '/' do
		@title = 'Welcome to Matcha'
		if current_user
			@users = User.all
			@user = User.find_by("id", current_user.id)
			erb :'user/search'
		else
	  	erb :'welcome/index'
		end
	end

end
