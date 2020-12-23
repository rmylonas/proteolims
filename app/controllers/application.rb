# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
include HoptoadNotifier::Catcher
class ApplicationController < ActionController::Base
	def set_styles
	    @header_class = 'header'
	    @odd_class = 'odd'
	    @box_div_class = 'box-div'
	    if(session[:active_tab] == 'client_experiments') 
	      @header_class = 'header-client-exp'
	      @odd_class = 'odd-client-exp'
	      @box_div_class = 'box-div client-exp-div'
	    elsif (session[:active_tab] == 'rppa_experiments')
	      @header_class = 'header-rppa-exp'
	      @odd_class = 'odd-rppa-exp'
	      @box_div_class = 'box-div rppa-exp-div'
	   	elsif (session[:active_tab] == 'paf_experiments')
	      @header_class = 'header-paf-exp'
	      @odd_class = 'odd-paf-exp'
	      @box_div_class = 'box-div paf-exp-div'
	   	end
   	end
end
