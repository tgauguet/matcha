class WelcomeController < ApplicationController
	helpers UserHelper
	helpers SortHelper
	helpers BlockHelper
	['/', '/search', '/search-filter'].each do |path|
		before path do
			authenticate
		end
	end

	get '/', allows: [:page, :per_page, :order] do
		@title = 'Welcome to Matcha'
		init_search(params['order']) if current_user
		current_user ? (erb :'user/search', :locals => {:order => params['order']}) : (erb :'welcome/index')
	end

	post "/search", allows: [:public_score, :location, :age, :personalized, :interested_in, :tags] do
		# Params interested_in is Bisexual by default
		puts params
		erb :'user/search'
	end

	post "/search-filter", allows: [:order] do
		order = params['order']
		init_search(order) if order
		erb :'user/search', :locals => {:order => order}
	end

	def init_search(order)
		@total_users = User.all(current_user.id)
		@total_users = set_order(order) if order
		@per_page = params['per_page'] ? params['per_page'].to_i : 20
		paginate(@total_users, params['page'], @per_page)
	end

	def set_order(order)
		if (order == "age" || order == "public_score")
			@total_users.sort_by { |u| u[order] }
		else
			@total_users.sort_by { |u| tags_count(u.to_dot.id) }.reverse
		end
	end

end
