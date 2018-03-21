class NotificationsController < ApplicationController
  helpers NotificationHelper

  get '/notification/index' do
    authenticate
    @notifications = Notification.all(current_user.id).to_a.reverse!
    mark_all_as_read
    erb :'notification/index'
  end

end
