# encoding: utf-8
require 'rubygems'
require 'active_support/core_ext/module/delegation'
require 'sinatra/base'
require 'rack-flash'
require 'thin'
require 'em-websocket'
require 'bcrypt'
require 'paperclip'
require 'paperclip/rack'
require 'hash_dot'
require 'sinatra/strong-params'
require 'nokogiri'
require 'open-uri'
require 'json'

class MatchaApp < Sinatra::Base
    require './config/db.rb'
    require './config/email.rb'

    configure :development do
      enable :sessions, :method_override
      Tilt.register Tilt::ERBTemplate, 'html.erb'
      Dir.glob('./app/{helpers,controllers,models,lib,data_models}/*.rb').each { |file| require file }
      set :database, {adapter: 'mysql', host: 'localhost', encoding: 'unicode', database: 'matcha', pool: 2}
      use Rack::Flash

      def herb(template, options={}, locals={})
        render "html.erb", template, options, locals
      end

      not_found do
    		status 404
    		redirect '/not-found'
    	end

    end

    use ApplicationController
    use WelcomeController
    use UsersController
    # # # use NotificationsController
    use ConversationsController
    use LikesController
    use BlocksController
end
