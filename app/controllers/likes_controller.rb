class LikesController < ApplicationController

  get '/like/index' do
    erb :'like/index'
  end

  get '/like/show' do
    erb :'like/show'
  end

end
