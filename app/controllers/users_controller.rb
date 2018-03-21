class UsersController < ApplicationController
	helpers UserHelper
	helpers MailHelper
	helpers LikesHelper
	helpers BlockHelper
	helpers TagHelper

	include FileUtils::Verbose
	['/images', '/edit', '/set-location', '/location', '/upload', '/edit-user'].each do |path|
		before path do
			authenticate
		end
	end
	['/user/new', '/user/login', '/forgot-password'].each do |path|
		before path do
			unauthenticate
		end
	end

	get '/user/new' do
		@title = "Inscription"
		set_default_location
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
		@user = current_user if signed_in?
		erb :'user/edit_password'
	end

	get '/user/:id/show' do
		authenticate
		@user = User.find_by("id", params[:id])
		redirect '/' unless @user
		@tags = Tagging.all(@user.id)
		@online = MyWS.online? @user.id
		@title = "Profil de #{@user.firstname} #{@user.name}"
		if @user.id != current_user.id
			if Visit.not_exists(@user.id, current_user.id) == 0
				Visit.new(@user.id, current_user.id)
				Notification.new("visit", @user.id, "#{current_user.login} a visité votre profil") unless Block.blocked?(current_user.id, @user.id)
				update_public_score(@user.id, 1)
			end
		end
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
			User.logged_in(@user.id)
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
		if @user
			token_match = signed_in? ? true : @user.password_token == params['token']
		end
		if len_match && password_match && token_match
			@user = User.update({'password' => params['password'], 'password_token' => " "}, @user)
			flash.now[:success] = "Le mot de passe a été modifié"
			signed_in? ? (erb :'user/edit_password') : (erb :'user/login')
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
		@user = User.find_by("email", params['email'])
		if @user
			@user = User.update({'password_token' => SecureRandom.hex[0,10].upcase.to_s}, @user)
			password_email(@user)
			flash.now[:notice] = "Nous vous avons envoyé un message pour modifier votre mot de passe. Checkez vos emails !"
		else
			flash.now[:notice] = "Impossible de trouver un utilisateur avec cet email"
		end
		redirect '/'
	end

	post '/edit-user', allows: [:interested_in, :description, :gender, :email, :name, :firstname, :age] do
		valid_email = params['email'].empty? ? 1 : update_params(params)
		valid_age = (!params['age'].empty?) &&  params['age'].to_i.to_s == params['age']
		if valid_age
			params['age'] = params['age'].to_i
			valid_age = (0 <= params['age'] && params['age'] <= 100)
		end
		if valid_email && valid_age
			@user = User.update(params, @user)
			if @user
				flash.now[:success] = "Votre profil a été modifié avec succès"
			else
				flash.now[:error] = "Une erreur est survenue pendant la modification de votre profil"
			end
		else
			flash.now[:error] = "Merci de vérifier vos paramètres"
		end
		erb :'user/edit'
	end

	post '/upload', allows: [:img1, :img2, :img3, :img4, :img5] do
		upload_images(params, @user)
		erb :'user/edit'
	end

	post '/set-location', allows: [:latitude, :longitude, :city] do
		update = edit_location(params, @user) unless (params['latitude'].nil? || params['longitude'].nil?)
		if update
			flash.now[:success] = "Votre localisation a été modifiée"
		else
			flash.now[:error] = "Erreur lors de la modification."
		end
		erb :'user/location'
	end

	post '/report-as-fake', allows: [:user_id] do
		user = User.find_by("id", params['user_id'])
		if User.update({'reported_as_fake' => 1}, user)
			flash[:success] = "L'utilisateur a été reporté comme faux compte"
		else
			flash[:error] = "Une erreur est survenue"
		end
		redirect back
	end

end
