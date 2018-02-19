class UsersController < ApplicationController
	helpers UserHelper
	helpers MailHelper
	include FileUtils::Verbose
	['/images', '/user/show', '/edit', '/upload', '/edit-password', '/edit-user'].each do |path|
		before path do
			authenticate
		end
	end

	get '/users' do
		@title = 'Tous les utilisateurs'
		@users = User.all
		erb :'user/index'
	end

	get '/user/new' do
		@title = "Inscription"
		erb :'user/new'
	end

	get '/images' do
		@title = "Images"
		erb :'user/images'
	end

	get '/user/show' do
		@title = "Profil de #{@user.firstname} #{@user.name}"
		erb :'user/show'
	end

	get '/user/login' do
		@title = "Connexion"
		erb :'user/login'
	end

	get '/edit' do
		@title = "Modification du profil"
		erb :'user/edit'
	end

	post '/login' do
		@user = User.match(params)
		if @user
			flash[:success] = "Vous êtes connecté"
			session[:current_user_id] = @user.id
			redirect '/'
		else
			flash.now[:error] = "Le mot de passe et/ou le login ne correspondent pas."
			erb :'user/login'
		end
	end

	get '/logout' do
		session[:current_user_id] = nil
		redirect '/'
	end

	post '/new', allows: [:name, :firstname, :password, :email, :login] do
		form_error = user_params(params)
		if form_error.empty?
			@user = User.new(params)
			if @user
				welcome_email(@user.email, @user.id)
				flash.now[:notice] = "Félicitations, vous êtes inscris sur Petsder !"
			else
				flash.now[:notice] = "Erreur lors de la sauvegarde, veuillez réessayer"
			end
			redirect '/'
		else
			flash.now[:errors] = form_error
			erb :'user/new'
		end
	end

	post '/edit-password', allows: [:password, :password_confirmation, :id, :token] do
		if (!validate_length_of(params['password'], 8) && (@user.password_token == params['token'] && params['password'] == params['password_confirmation']))
			@user = User.update({'password' => params['password']}, @user)
			flash.now[:success] = "Le mot de passe a été modifié"
			erb :'user/login'
		else
			flash.now[:error] = "Une erreur est survenue"
			erb :'user/edit_password'
		end
	end

	get '/forgot-password' do
		@title = "Mot de passe oublié"
		erb :'user/forgot_password'
	end

	get '/new-password' do
		@title = "Modifier le mot de passe"
		erb :'user/edit_password'
	end

	post '/send-password-email', allows: [:email] do
		@user = User.find_by("email", params[:email])
		if @user
			@user = User.update({password_token: SecureRandom.urlsafe_base64.to_s}, @user)
			password_email(@user)
			flash.now[:notice] = "Nous vous avons envoyé un message pour modifier votre mot de passe. Checkez vos emails !"
		else
			flash.now[:notice] = "Impossible de trouver un utilisateur avec cet email"
		end
		redirect '/'
	end

	post '/edit-user', allows: [:interested_in, :description, :gender, :email, :name, :firstname] do
		valid_email = params['email'].empty? ? 1 : update_params(params)
		if valid_email
			@user = User.update(params, @user)
			if @user
				flash.now[:success] = "Votre profil a été modifié avec succès"
			else
				flash.now[:error] = "Une erreur est survenue pendant la modification de votre profil"
			end
		else
			flash.now[:error] = "Une erreur est survenue, vérifiez vos paramètres"
		end
		erb :'user/edit'
	end

	post '/upload' do
		upload_images(params, @user)
		erb :'user/edit'
	end

	post '/go' do
	end

	def authenticate
		@user = current_user
		redirect '/' unless @user
	end

end
