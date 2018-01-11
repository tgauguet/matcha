class WelcomeController < ApplicationController

	get '/' do
		@title = 'Welcome to Matcha'
		@user = User.find(current_user.id)
	  	erb :'welcome/index'
	end

	post '/go' do
	    erb :'welcome/index'
	end

end
