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
		params.to_s
		@user = User.new(params)
		if @user.save
			@user.update(confirm_token: SecureRandom.urlsafe_base64.to_s)
			token = @user.confirm_token
			email = @user.email
			id = @user.id
			mail = Mail.new do
			  from    'noreply@matcha.com'
			  to      email
			  subject 'Confirmation email'
			  html_part do
			    content_type 'text/html; charset=UTF-8'
			    body "<h1>Click on the link below to confirm your email :</h1><br/>
					<a href='http://localhost:4567/confirm?token=#{token}&id=#{id}'>Confirm email</a>"
			  end
			end
			mail.deliver
			flash[:notice] = "Congratulations, you can now confirm your account. Check your emails !"
			redirect '/'
		else
			flash[:error] = @user.errors.full_messages
			erb :'user/new'
		end
	end

	get '/confirm' do
		@user = User.find(params[:id])
		if (@user.confirmed? && @user.confirm_token.blank?)
			flash[:success] = "Your email has already been confirmed."
			erb :'user/login'
		else
			if (params[:id] == @user.id.to_s && params[:token] == @user.confirm_token)
				@user.update(confirmed: true, confirm_token: "")
				flash[:success] = "Your email has been confirmed !"
				erb :'user/login'
			else
				flash[:notice] = "An error occured, please try to confirm your email again"
				erb :'user/new'
			end
		end
	end

end
