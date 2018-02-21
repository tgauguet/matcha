class LikesController < ApplicationController
  helpers LikesHelper
  helpers UserHelper
  ['/likes/index'].each do |path|
		before path do
			authenticate
		end
	end

  get '/likes/index' do
    @likes = Liked.all(@user.id)
    erb :'like/index'
  end

  post '/like' do
    if to_delete?(params['user_id'])
      flash[:success] = "Vous ne likez plus ce profil" if Liked.delete(params)
    else
      flash[:success] = "Vous avez liké ce profil" if Liked.new(params)
    end
    flash[:error] = "Une erreur est survenue" unless flash[:success]
    redirect back
  end

  def authenticate
		@user = current_user
		redirect '/' unless @user
	end

end
