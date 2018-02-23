class NotificationsController < ApplicationController
  helpers NotificationHelper

  get '/notification/index' do
    @notifications = Notification.all(current_user.id)
    erb :'notification/index'
  end

end
