require 'sinatra'
require 'thin'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './app/models/user'

Tilt.register Tilt::ERBTemplate, 'html.erb'

def herb(template, options={}, locals={})
  render "html.erb", template, options, locals
end

Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

use WelcomeController
use UsersController
use ApplicationController
