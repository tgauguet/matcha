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

	get '/edit' do
		@user = current_user.id
		erb :'user/edit'
	end

	post '/login' do
		@user = User.find_by(login: params[:login], email: params[:email]).try(:authenticate, params[:password])
		if @user
			flash[:success] = "You are logged in."
			session[:current_user_id] = @user.id
			redirect '/'
		else
			flash[:notice] = "An error occured, please try again."
			erb :'user/login'
		end
	end

	get '/logout' do
		session[:current_user_id] = ""
		redirect '/'
	end

	post '/new', allows: [:name, :firstname, :password, :password_confirmation, :email, :login] do
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

	get '/forgot-password' do
		erb :'user/forgot_password'
	end

	get '/new-password' do
		erb :'user/edit_password'
	end

	post '/send-password-email' do
		@user = User.find_by(email: params[:email])
		if @user
			@user.update(password_token: SecureRandom.urlsafe_base64.to_s)
			token = @user.password_token
			email = @user.email
			id = @user.id
			mail = Mail.new do
			  from    'noreply@matcha.com'
			  to      email
			  subject 'Reset password'
			  html_part do
			    content_type 'text/html; charset=UTF-8'
			    body "<h1>Click on the link below to reset your password :</h1><br/>
					<a href='http://localhost:4567/new-password?token=#{token}&id=#{id}'>Reset password</a>"
			  end
			end
			mail.deliver
			flash[:notice] = "We sended you an email to change your password, please check your mailbox."
		else
			flash[:notice] = "We couldn't find a user with this email."
		end
		redirect '/'
	end

	post '/edit-password' do
		@user = User.find_by(id: params[:id])
		if (@user.password_token == params[:password_token])
			if (params[:password] ==  params[:password_confirmation])
				@user.update(password: params[:password])
				flash[:success] = "Password has been updated."
			else
				flash[:notice] = "Password confirmation do not match password"
			end
		else
			flash[:notice] = "An error occured."
		end
		erb :'user/login'
	end

end
