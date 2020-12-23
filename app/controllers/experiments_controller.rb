class ExperimentsController < ApplicationController
	layout "application", :except => [:list_filtered]
	helper 'samples'

  def index
    session[:active_tab] = params[:active_tab]
		@body_id = "tab2"
    list
    render :action => 'list'
  end

  def search
		#@phrase = request.raw_post || request.query_string
		#matcher = Regex.new( @phrase )
  	#@exps = Project.find_by_name(@phrase)
		render 'export'
  end

  def export
		filename = "experiments-" + Time.now.strftime('%Y%m%d') + ".xls"
  	headers["Content-Type"] = "application/vnd.ms-excel"
  	headers["Content-Disposition"] = "attachment; filename=#{filename}"
		headers['Cache-Control'] = ''
  	@exps = Experiment.find :all
		#send_data( render_to_string('experiments'), :filename=> '/tmp/results.csv' )
		render :layout => false
  end

  def list_filtered
    set_styles()
		#keyword = '"' + "name LIKE '%" + params['keyword'] + "%'" + '"'
		#logger.debug( "keyword: #{keyword}" )
		if params[:keyword] == "" or params[:field] == "" or params[:keyword].length < 3
    	list	
			@only_table = true
			render :action => 'list', :layout => false
		else
      exp_type = session[:active_tab] == 'paf_experiments' ? 1 : 0
      exp_type = session[:active_tab] == 'rppa_experiments' ? 2 : exp_type
			if params[:field] == "project"
				#@projects = Project.paginate :page => params[:page], :joins => :experiments, :conditions =>[ "(name LIKE ?) AND (experiments.is_internal = ?)", "%#{params['keyword']}%", look_for_interal], :order => "updated_on DESC", :per_page => 50, :group => :id
				@projects = Project.find(:all, :joins => :experiments, :conditions =>[ "(name LIKE ?) AND (experiments.exp_type = ?)", "%#{params['keyword']}%", exp_type], :order => "updated_on DESC", :group => :id)
        if (@projects.size == 0)
					render :text => "No projects found with the keyword " + params[:keyword]
				else
					render #_list_filtered
				end
			else
				@experiments = Experiment.paginate :page => params[:page], :conditions =>[ "(hypothesis LIKE ? OR annotation LIKE ?) AND (experiments.exp_type = ?)", "%#{params['keyword']}%", "%#{params['keyword']}%", exp_type], :order => "created_on DESC", :per_page => 50
				
				render :partial => "list_experiments", :locals => { :experiments => @experiments, :keyword => params[:keyword] }, :layout => false
			end
			#render :text => params.inspect, :layout => false
		end
  end

	def by_date
		@experiments = Experiment.find( :all, :conditions => ["year(created_on) >= ? AND month(created_on) >= ?", params[:year], params[:month] ] )
		#render :text => @experiments.inspect
		@paginate = false
		render :action => 'list'
	end

  def list
    set_styles()
		if not params.include?(:page)
			params[:page] = 1
		end
    exp_type = session[:active_tab] == 'paf_experiments' ? 1 : 0
    exp_type = session[:active_tab] == 'rppa_experiments' ? 2 : exp_type
    @experiment_count = Experiment.find( :all, :conditions =>[ "(exp_type = ?)", exp_type ]).count
		@experiments = Experiment.paginate :page => params[:page], :order => "updated_on DESC", :per_page =>20, :conditions =>[ "(exp_type = ?)", exp_type ]
    #render :file => 'experiments/list.rxml', :locals => { :header_class => @header_class}
  end


  def show
    set_styles()
		respond_to do |format|
    	@experiment = Experiment.find(params[:id], :order => "created_on DESC" )
			format.html {
				session[:prev_loc] = request.request_uri
				@background = "#eee";
			}
			format.xml  { render :file => 'experiments/show.rxml', :layout => false, :use_full_path => true }
		end
  end

  def new
    @experiment = Experiment.new
  end

  def create
    @experiment = Experiment.new(params[:experiment])
    if @experiment.save
      flash['notice'] = 'Experiment was successfully created.'
      redirect_to :protocol => 'https://', :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @experiment = Experiment.find(params[:id])
  end

  def update
    update_date = params[:update_date]
    if update_date[:valueupdate_date].to_i == 0
      Experiment.record_timestamps = false
    end  
    @experiment = Experiment.find(params[:id])
    update_status = @experiment.update_attributes(params[:experiment])
    Experiment.record_timestamps = true

    if update_status
      flash['notice'] = 'Experiment was successfully updated.'
      redirect_to :protocol => 'https://', :action => 'show', :id => @experiment
    else
      render_action 'edit'
    end
  end

  def destroy
    e = Experiment.find(params[:id])
		#e.deleted = 'y'
		#e.save
		e.destroy
    redirect_to :protocol => 'https://', :action => 'list'
  end

  #def add_sample
	#	@exp = Experiment.find(params[:id])
	#	@sample = Sample.new
	##	@exp.samples << @sample
	#	@exp.save
	#end


  def import_samples

    @experiment = Experiment.find(params[:id])
    #@experiment = Experiment.find(params[:id], :include => :project)
    if request.post?
      render :text => params['samples']['samples'].split("\n")[0].chomp.split("\t").inspect
    else
      # do something
    end

  end

  def update_status
    bill_done = (params[:bill_done]) ? 1 : 0
    experiment = Experiment.find(params[:exp_id].to_i)
    experiment.bill_done = bill_done
    experiment.exp_type = params[:exp_type].to_i
    experiment.status = params[:status].to_i
    Experiment.record_timestamps = false
    experiment.save
    Experiment.record_timestamps = true
    render :partial => "experiment_status", :locals => {
      :exp_id => params[:exp_id], 
      :bill_done => params[:bill_done],
      :exp_type => params[:exp_type],
       :status => params[:status].to_i
     }
  end

end
