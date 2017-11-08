class WelcomeController < ApplicationController

	get '/' do
		@title = 'Welcome to Matcha'
	  	erb :'welcome/index'
	end

end