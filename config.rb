require 'rack-flash'
require 'sinatra'
require 'thin'
require 'active_support/core_ext/module/delegation'
require 'paperclip'
require 'paperclip/rack'
require 'pony' #email sender
require 'sinatra/strong-params'
require 'nokogiri'
require 'open-uri'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './app/models/user'
require './app/models/tagging'
require './app/models/tag'

Tilt.register Tilt::ERBTemplate, 'html.erb'

def herb(template, options={}, locals={})
  render "html.erb", template, options, locals
end

Mail.defaults do
  delivery_method :smtp,
  address: "smtp.gmail.com",
  port: 587,
  user_name: "fakefakematcha@gmail.com",
  password: "fakeaccountpassword",
  authentication: "plain"
end

enable :sessions, :method_override
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

use Rack::Flash
use WelcomeController
use UsersController
use ApplicationController
use ConversationsController
use LikesController
