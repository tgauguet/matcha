class WelcomeController < ApplicationController

	get '/' do
		@title = 'Welcome to Matcha'
		if current_user
			@user = User.find(current_user.id)
			@users = User.all
			erb :'user/search'
		else
	  	erb :'welcome/index'
		end
	end

end
