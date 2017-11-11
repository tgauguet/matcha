$:.unshift(File.expand_path('../../lib', __FILE__))

class ApplicationController < Sinatra::Base
	set :root, File.join(File.dirname(__FILE__), '..')
	set :views, Proc.new { File.join(root, "views") }
	set :public_folder, Proc.new { File.join(root, "public") }
	#helpers ApplicationHelpers
	after do
	  ActiveRecord::Base.connection.close
	end

	#use AssetHandler

	not_found{ slim :not_found }
end
