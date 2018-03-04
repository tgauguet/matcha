class VisitsController < ApplicationController
  helpers UserHelper

  get '/visits/index' do
    @title = "Tous vos visiteurs"
    authenticate
    @visits = Visit.all(current_user.id)
    erb :'visit/index'
  end

end
