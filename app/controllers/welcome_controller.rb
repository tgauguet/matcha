class WelcomeController < ApplicationController
	helpers UserHelper
	helpers SortHelper
	helpers BlockHelper
	['/', '/search', '/search-filter'].each do |path|
		before path do
			authenticate
		end
	end

	get '/', allows: [:page, :per_page] do
		@title = 'Welcome to Matcha'
		if current_user
			@total_users = User.all(current_user.id)
			init_search
		end
		current_user ? (erb :'user/search') : (erb :'welcome/index')
	end

	post "/search", allows: [:public_score, :location, :age, :personalized, :interested_in, :tags] do
		# Params interested_in is Bisexual by default
		puts params
		erb :'user/search'
	end

	post "/search-filter", allows: [:order] do
		@total_users = User.all(current_user.id)
		order = params['order']
		if order
			@total_users = @total_users.sort_by { |u| u[order] }
			init_search
		end
		erb :'user/search'
	end

	def init_search
		@per_page = params['per_page'] ? params['per_page'].to_i : 20
		paginate(@total_users, params['page'], @per_page)
	end

end
