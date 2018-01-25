class ConversationsController < ApplicationController

	get '/conversation/index' do
		erb :'conversation/index'
	end

  get '/conversation/show' do
    erb :'conversation/show'
  end

end
