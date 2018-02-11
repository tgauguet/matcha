require 'rubygems'
require 'active_support/core_ext/module/delegation'
require 'sinatra'
require 'rack-flash'
require 'thin'
require 'paperclip'
require 'paperclip/rack'
require 'sinatra/strong-params'
require 'nokogiri'
require 'open-uri'
require './config/environments'
require './config/db'
require './config/email'
require 'mysql'

Tilt.register Tilt::ERBTemplate, 'html.erb'

def herb(template, options={}, locals={})
  render "html.erb", template, options, locals
end

enable :sessions, :method_override
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

use Rack::Flash
use WelcomeController
# use UsersController
# use NotificationsController
# use ApplicationController
# use ConversationsController
# use LikesController
