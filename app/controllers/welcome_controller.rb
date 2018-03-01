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

	post "/search", allows: [:public_score, :location, :age, :personalized, :interested_in, :tags, :order] do
		params['id'] = current_user.id.to_s
		order = params['order']
		init_search(order) if order
		puts params
		@users = User.all_according_to(params)
		erb :'user/search', :locals => {:order => order}
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

end
