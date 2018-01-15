class WelcomeController < ApplicationController

	get '/' do
		@title = 'Welcome to Matcha'
		if current_user
			@user = User.find(current_user.id)
		end
	  erb :'welcome/index'
	end

	post '/go' do
	    erb :'welcome/index'
	end

end
