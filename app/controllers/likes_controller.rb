class LikesController < ApplicationController
  helpers LikesHelper
  helpers UserHelper
  helpers ConversationHelper
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
      if Liked.delete(params)
        flash[:success] = "Vous ne likez plus ce profil"
        Notification.new("unmatch", params['user_id'], "#{@user.login} a supprimé votre match")
      end
    elsif Liked.new(params)
      flash[:success] = "Vous avez liké ce profil"
      Notification.new('like', params['user_id'], "#{@user.login} a liké votre profil")
      if not_exists?(params['user_id']) == 1
        Conversation.new(@user.id, params['user_id']) if its_a_match?(params['user_id'])
      end
      if its_a_match?(params['user_id'])
        match_notifications(params['user_id'])
      end
    end
    flash[:error] = "Une erreur est survenue" unless flash[:success]
    redirect back
  end

end
