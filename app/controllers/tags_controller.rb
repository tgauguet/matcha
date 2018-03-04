class TagsController < ApplicationController
  helpers TagHelper
  helpers UserHelper
  before '/tags/new' do
    authenticate
  end

  get '/tags/new' do
    @title = "Mes tags"
    @tags = Tagging.all(current_user.id)
    erb :'tag/new'
  end

  post '/tags/new', allows: [:content] do
    @content = params['content'].split(/\s*,\s*/)
    tags = []
    if @content
      @content.each do |content|
        exists = Tag.exists?(content)
        if exists
          @tag = Tagging.new(current_user.id, exists.to_dot.id) unless Tagging.exists?(current_user.id, exists.to_dot.id)
          tags << @tag if @tag
        else
          tag = Tag.new(content)
          if tag
            @tag = Tagging.new(current_user.id, tag)
            tags << @tag if @tag
          end
        end
      end
      if !tags.empty?
        flash.now[:success] = "Félicitations, vous avez créé #{tags.count} tag(s)"
      else
        flash.now[:error] = "Le/les tags sont déjà existants"
      end
    end
    @tags = Tagging.all(current_user.id)
    erb :'tag/new'
  end

end
