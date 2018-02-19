class UsersController < ApplicationController
	helpers UserHelper
	helpers MailHelper
	include FileUtils::Verbose

	get '/users' do
		@title = 'Tous les utilisateurs'
		@users = User.all
		erb :'user/index'
	end

	get '/user/new' do
		@title = "Inscription"
		erb :'user/new'
	end

	get '/user/show' do
		@user = User.find_by("id", params[:id])
		@title = "Profil de #{@user['firstname']} #{@user['name']}"
		erb :'user/show'
	end

	get '/user/login' do
		@title = "Connexion"
		erb :'user/login'
	end

	get '/edit' do
		@title = "Modification du profil"
		@user = current_user.id
		erb :'user/edit'
	end

	post '/login' do
		@user = User.match(params)
		if @user
			flash[:success] = "Vous êtes connecté"
			session[:current_user_id] = @user.id
			redirect '/'
		else
			flash[:error] = "Le mot de passe et/ou le login ne correspondent pas."
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
				flash[:notice] = "Félicitations, vous êtes inscris sur Petsder !"
			else
				flash[:notice] = "Erreur lors de la sauvegarde, veuillez réessayer"
			end
			redirect '/'
		else
			flash[:errors] = form_error
			erb :'user/new'
		end
	end

	post '/edit-password', allows: [:password, :password_confirmation, :id, :token] do
		@user = User.find_by("id", params['id'])
		if (@user && !validate_length_of(params['password'], 8) && (@user.password_token == params['token'] && params['password'] == params['password_confirmation']))
			@user = User.update({'password' => params['password']}, @user)
			flash[:succes] = "Le mot de passe a été modifié"
			erb :'user/login'
		else
			flash[:error] = "Une erreur est survenue"
			erb :'user/edit_password'
		end
	end

	# to be deleted
	get '/confirm' do
		@title = "Confirmation de votre email"
		@user = User.find_by("id", params[:id])
		if (@user.confirmed? && @user.confirm_token.blank?)
			flash[:success] = "Votre email a déjà été confirmé"
			erb :'user/login'
		else
			if (params[:id] == @user.id.to_s && params[:token] == @user.confirm_token)
				@user.update(confirmed: true, confirm_token: "")
				flash[:success] = "Votre email vient d'être confirmé !"
				erb :'user/login'
			else
				flash[:notice] = "Une erreur est survenue, merci de réessayer"
				erb :'user/new'
			end
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
			flash[:notice] = "Nous vous avons envoyé un message pour modifier votre mot de passe. Checkez vos emails !"
		else
			flash[:notice] = "Impossible de trouver un utilisateur avec cet email"
		end
		redirect '/'
	end

	post '/edit-user', allows: [:interested_in, :bio, :gen, :all_tags, :email] do
		@user = User.find_by(id: current_user.id)
		if @user
			if @user.update(params)
				flash[:success] = "Votre profil a été modifié avec succès"
			else
				flash[:notice] = "Une erreur est survenue pendant la modification de votre profil"
			end
		end
		erb :'user/edit'
	end

	post '/upload' do
		@user = User.find_by(id: current_user.id)
		if params[:img1]
			copy_image(params[:img1], @user, 1)
		end
		if params[:img2]
			copy_image(params[:img2], @user, 2)
		end
		if params[:img3]
			copy_image(params[:img3], @user, 3)
		end
		if params[:img4]
			copy_image(params[:img4], @user, 4)
		end
		if params[:img5]
			copy_image(params[:img5], @user, 5)
		end
		erb :'user/edit'
	end

	def copy_image(image, user, num)
		@img = image[:filename]
		file = image[:tempfile]
		cp(file, "./app/public/files/#{@img}")
		img1 = (num == 1 ? @img : user.img1)
		img2 = (num == 2 ? @img : user.img2)
		img3 = (num == 3 ? @img : user.img3)
		img4 = (num == 4 ? @img : user.img4)
		img5 = (num == 5 ? @img : user.img5)
		if user
			if user.update(img1: img1, img2: img2, img3: img3, img4: img4, img5: img5)
				flash[:success] = "Vos images ont été ajoutées avec succès"
			else
				flash[:notice] = "Une erreur est apparue lors de la modification de votre profil"
			end
		end
	end

	post '/go' do
	end

end
