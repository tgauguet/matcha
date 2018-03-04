class WelcomeController < ApplicationController
	helpers UserHelper
	helpers SortHelper
	helpers BlockHelper
	['/', '/search', '/search-filter'].each do |path|
		before path do
			authenticate
		end
	end

	get '/', allows: [:location, :min_age, :max_age, :min_score, :max_score, :personalized, :gender, :tags, :order, :page, :per_page] do
		prepare_users_list(params)
		current_user ? (erb :'user/search', :locals => params) : (erb :'welcome/index')
	end

	post "/search", allows: [:location, :min_age, :max_age, :min_score, :max_score, :personalized, :gender, :tags, :order, :page, :per_page] do
		prepare_users_list(params)
		erb :'user/search', :locals => params
	end

	def prepare_users_list(params)
		@title = "Matcha"
		params['order'] = params['order'] ? params['order'] : "id"
		generate_users_list(params)
		paginate(params)
	end

end
