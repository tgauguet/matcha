class ConversationsController < ApplicationController
	helpers ConversationHelper
	helpers UserHelper
	['/conversation/index', '/conversation/:id/show', '/new-message'].each do |path|
		before path do
			authenticate
		end
	end

	get '/conversation/index' do
		@user = current_user
		redirect '/' unless @user
		@conversations = UserConversation.all(@user.id)
		erb :'conversation/index'
	end

  get '/conversation/:id/show' do
		init_conversation(@user.id, params[:id])
    erb :'conversation/show'
  end

	post '/new-message', allows: [:message, :conversation_id] do
		if params['message']
			Message.new(params['message'], @user.id, params['conversation_id'])
		end
		redirect back
	end

	def authenticate
		@user = current_user
		redirect '/' unless @user
	end

end
