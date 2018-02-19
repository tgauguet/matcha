require 'rubygems'
require 'active_support/core_ext/module/delegation'
require 'sinatra'
require 'rack-flash'
require 'thin'
require 'bcrypt'
require 'paperclip'
require 'paperclip/rack'
require 'hash_dot'
require 'sinatra/strong-params'
require 'nokogiri'
require 'open-uri'
require 'json'
require './config/environments'
require './config/db'
require './config/email'

configure do

  enable :sessions, :method_override
  Tilt.register Tilt::ERBTemplate, 'html.erb'
  Dir.glob('./app/{helpers,controllers,models,lib,data_models}/*.rb').each { |file| require file }

  def herb(template, options={}, locals={})
    render "html.erb", template, options, locals
  end

  use Rack::Flash
  use WelcomeController
  use UsersController
  # use NotificationsController
  # use ApplicationController
  # use ConversationsController
  # use LikesController

end
