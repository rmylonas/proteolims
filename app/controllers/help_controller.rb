class HelpController < ApplicationController
	def index
		session[:active_tab] = params[:active_tab]
	end

end
