class WelcomeController < ApplicationController
	helpers UserHelper
	helpers SortHelper
	helpers BlockHelper
	['/', '/search', '/search-filter'].each do |path|
		before path do
			authenticate
		end
	end

	get '/', allows: [:location, :min_age, :max_age, :min_score, :max_score, :personalized, :interested_in, :tags, :order, :page, :per_page] do
		@title = 'Welcome to Matcha'
		puts params
		params['order'] = params['order'] ? params['order'] : "id"
		generate_users_list(params)
		paginate(@total_users, params)
		current_user ? (erb :'user/search', :locals => params) : (erb :'welcome/index')
	end

	post "/search", allows: [:location, :min_age, :max_age, :min_score, :max_score, :personalized, :interested_in, :tags, :order, :page, :per_page] do
		@title = "Recherche"
		puts params
		params['order'] = params['order'] ? params['order'] : "id"
		generate_users_list(params)
		paginate(@total_users, params)
		erb :'user/search', :locals => params
	end

	def personalized_search(order, params)
		list = generate_tags_list(params["tags"])
		@total_users = User.all_according_to(params)
		@total_users = @total_users.select { |u| get_distance(user_location,loc_params(u)) <= params['location'].to_i } if params['location']
		@total_users = @total_users.select { |u| tags_match(list,u.to_dot.id) > 0 } if params["tags"] != ""
		# @total_users = User.all_personalized(current_user.id, params)
		paginate(@total_users, params['page'], @per_page, order)
	end

end
