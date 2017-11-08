class UsersController < ApplicationController

	get '/users' do
		@title = 'Utilisateurs'
		@users = User.all
		erb :'user/index'
	end

	get '/user/new' do
		@title = "Sign in"
		erb :'user/new'
	end

	get '/user/login' do
		@title = "Login"
		erb :'user/login'
	end

	post '/new' do
		@user = User.new(params[:user])
		if @user.save
			redirect '/'
		else
			"Sorry, there was an error."
		end
	end
end