class Sample < ActiveRecord::Base
	belongs_to :experiment
	belongs_to :sample_origin
	belongs_to :person

	def mascot_result_files
	
		if (not mascot_search_results.nil?)
			if mascot_search_results =~ /,/
				res = {}
				mascot_search_results.split(',').each do |m|
					m.strip!
					f = get_mascot_result_file( m )
					res[m] = f
				end
				return res
			else
				# single entry only
				f = get_mascot_result_file( mascot_search_results )
				return { mascot_search_results => f }
			end
		else
			logger.info( "search_log_id is nil" )
			""
		end

	end


	def bulk_import(samples)
		transaction do 
			samples.each do |s|
				sample = Sample.new
				sample.experiment_id = s[0]
				sample.tube = s[1]
				sample.sample_name = s[2]
				
				# select sample origin if possible
				sample_origin = SampleOrigin.find_by_id(s[3])
				sample.sample_origin = sample_origin != nil ? sample_origin : SampleOrigin.find(1)

				sample.sample_date = s[4]
				sample.provider = s[5]
				sample.annotation = s[6]
				sample.description = s[7]
				sample.analysis_type = s[8]
				sample.bill_done = s[9]
				sample.save
			end
		end
		
	end

  #def bill_done
  #  b = attributes['bill_done']
	#	case b
	#		when 'y': 'Yes'
	#		when 'n': 'No'
	#		when 'na': 'N.A'
	#	end
  #end

private

	def get_mascot_result_file( f )
					cmd = "grep '^#{f}' /usr/local/mascot/current/logs/searches.log"
					x = `#{cmd}`
					n = x.split("\t")
					logger.info( "Grep res: #{cmd}")
					logger.info( "Mascot search result filename inspect: #{n.size}")
					logger.info( "Mascot search result filename: #{n[6]}")
					n[6]
	end

end
