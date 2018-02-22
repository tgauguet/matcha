class LikesController < ApplicationController
  helpers LikesHelper
  helpers UserHelper
  ['/likes/index', '/like'].each do |path|
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
    elsif Liked.new(params)
      flash[:success] = "Vous avez liké ce profil"
      Conversation.new(@user.id, params['user_id']) if its_a_match?(params['user_id'])
    end
    flash[:error] = "Une erreur est survenue" unless flash[:success]
    redirect back
  end

  def authenticate
		@user = current_user
		redirect '/' unless @user
	end

end
