$:.unshift(File.expand_path('../../lib', __FILE__))

class ApplicationController < Sinatra::Base
	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") } 
	set :public_folder, Proc.new { File.join(root, "public") } 
	set :header, 
	#helpers ApplicationHelpers
	enable :sessions, :method_override

	#use AssetHandler

	not_found{ slim :not_found }
end