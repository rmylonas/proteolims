# PAF LIMS 1.0 stored just the search log id (12345) but 1.5
# stores the full URL to the result file.  
# 
# This ruby script changes existing 1.0 format to new 1.5 format.

require 'config/environment'

url = 'http://pcib306.unil.ch/mascot/cgi/master_results.pl?file='

Sample.find(:all).each do |s|
	puts s.id
	next if s.mascot_search_results !~ /\d+/
	if not s.mascot_search_results.nil?
		if (s.mascot_search_results !~ /,/) 
			x = `grep '^#{s.mascot_search_results}' searches.log | awk -F'\t' '{print $7}'`
			s.mascot_search_results = url + x
			s.save
		else
			mss = []
			puts s.mascot_search_results
			s.mascot_search_results.split(',').each do |ms|
				ms.strip!
				x = `grep '^#{ms}' searches.log | awk -F'\t' '{print $7}'`
				mss << url + x
			end
			s.mascot_search_results = mss.join(',')
			s.save
		end
	end
	puts
end
