class BlocksController < ApplicationController
  helpers BlockHelper

  post '/block' do
    if block_to_delete?(params['user_id'])
      flash[:success] = "Vous avez débloqué cet utilisateur" if Block.delete(params)
    else
      flash[:success] = "Vous avez bloqué cet utilisateur" if Block.new(params)
      update_public_score(params['user_id'], -1)
    end
    flash[:error] = "Une erreur est survenue" unless flash[:success]
    redirect back
  end

end
