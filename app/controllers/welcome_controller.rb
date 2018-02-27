class WelcomeController < ApplicationController
	helpers UserHelper

	get '/', allows: [:page] do
		@title = 'Welcome to Matcha'
		if current_user
			@user = User.find_by("id", current_user.id)
			@users = User.all
			if params['page']
				@page = params['page']
				min = params['page'].to_i * 20
				max = min + 19
			else
				@page = "1"
			end
			erb :'user/search'
		else
	  	erb :'welcome/index'
		end
	end

end
