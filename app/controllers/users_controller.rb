class UsersController < ApplicationController
	helpers UserHelper
	helpers MailHelper
	helpers LikesHelper
	helpers BlockHelper
	include FileUtils::Verbose
	['/images', '/edit', '/set-location', '/location', '/upload', '/edit-user'].each do |path|
		before path do
			authenticate
		end
	end

	get '/user/new' do
		@title = "Inscription"
		erb :'user/new'
	end

	get '/images' do
		@title = "Images"
		erb :'user/images'
	end

	get '/location' do
		@title = "Géolocalisation"
		erb :'user/location'
	end

	get '/edit-password' do
		@title = 'Modifier votre mot de passe'
		erb :'user/edit_password'
	end

	get '/user/:id/show' do
		@user = User.find_by("id", params[:id])
		redirect '/' unless @user
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

	post '/new', allows: [:name, :firstname, :password, :email, :login, :latitude, :longitude] do
		form_error = user_params(params)
		if form_error.empty?
			@user = User.new(params)
			if @user
				welcome_email(@user.email, @user.id)
				flash[:success] = "Félicitations, vous êtes inscris sur Petsder !"
			else
				flash[:error] = "Erreur lors de la sauvegarde, veuillez réessayer"
			end
			redirect '/'
		else
			flash.now[:errors] = form_error
			erb :'user/new'
		end
	end

	post '/edit-password', allows: [:password, :password_confirmation, :id, :token] do
		@user = signed_in? ? current_user : User.find_by("id", params['id'])
		len_match = !validate_length_of(params['password'], 8)
		password_match = params['password'] == params['password_confirmation']
		token_match = signed_in? ? true : @user.password_token == params['token']
		if len_match && password_match && token_match
			@user = User.update({'password' => params['password']}, @user)
			flash.now[:success] = "Le mot de passe a été modifié"
			erb :'user/edit_password' if signed_in? rescue erb :'user/login'
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

	post '/set-location' do
		update = edit_location(params, @user) unless (params['latitude'].nil? || params['longitude'].nil?)
		if update
			flash.now[:success] = "Votre localisation a été modifiée"
		else
			flash.now[:error] = "Erreur lors de la modification."
		end
		erb :'user/location'
	end

	post '/report-as-fake' do
		user = User.find_by("id", params['user_id'])
		if User.update({'reported_as_fake' => 1}, user)
			flash[:success] = "L'utilisateur a été reporté comme faux compte"
		else
			flash[:error] = "Une erreur est survenue"
		end
		redirect back
	end

end
