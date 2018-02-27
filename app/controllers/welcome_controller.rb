class WelcomeController < ApplicationController
	helpers UserHelper
	helpers SortHelper
	helpers BlockHelper

	get '/', allows: [:page, :per_page] do
		@title = 'Welcome to Matcha'
		if current_user
			@user = User.find_by("id", current_user.id)
			@tags = Tag.all
			users = User.all(current_user.id)
			@per_page = params['per_page'] ? params['per_page'].to_i : 20
			paginate(users, params['page'], @per_page)
			erb :'user/search'
		else
	  	erb :'welcome/index'
		end
	end

end
