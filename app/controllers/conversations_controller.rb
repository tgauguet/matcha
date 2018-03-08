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
		@conversations = UserConversation.all(@user.id).to_a.reverse!
		erb :'conversation/index'
	end

  get '/conversation/:id/show' do
		init_conversation(@user.id, params[:id])
    erb :'conversation/show'
  end

	post '/new-message', allows: [:message, :conversation_id, :interlocutor_id] do
		@interlocutor = get_interlocutor(@user.id, params['conversation_id'])
		if params['message']
			Message.new(params['message'], @user.id, params['conversation_id'])
			Notification.new("message", @interlocutor.id, "#{@interlocutor.login} vous a envoyé un message") unless Block.blocked?(@user.id, @interlocutor.id)
			update_public_score(@interlocutor.id, 1)
		end
		redirect back
	end

end
