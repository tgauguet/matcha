class NotificationsController < ApplicationController

  get '/notification/index' do
    erb :'notification/index'
  end

end
