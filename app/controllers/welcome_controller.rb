class WelcomeController < ApplicationController
	helpers UserHelper
	helpers SortHelper
	helpers BlockHelper
	['/search', '/search-filter'].each do |path|
		before path do
			authenticate
		end
	end

	get '/', allows: [:location, :min_age, :max_age, :min_score, :max_score, :personalized, :gender, :tags, :order, :page, :per_page] do
		if current_user
			prepare_users_list(params)
			erb :'user/search', :locals => params
		else
			erb :'welcome/index'
		end
	end

	get "/search", allows: [:location, :min_age, :max_age, :min_score, :max_score, :personalized, :gender, :tags, :order, :page, :per_page] do
		prepare_users_list(params)
		erb :'user/search', :locals => params
	end

	def prepare_users_list(params)
		@title = "Matcha"
		params['order'] = params['order'] ? params['order'] : "id"
		generate_users_list(params)
		paginate(params)
		{:location => "", :min_age  => "0", :max_age  => "100", :min_score  => "0", :max_score  => "100", :personalized  => "", :gender  => "", :tags  => "", :order => ""}.each{ |d, v|
			unless params[d]
				params[d] = v
			end
		}
	end

end
