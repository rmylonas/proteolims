class AddIsInternalToExperiments < ActiveRecord::Migration
	def self.up
    		add_column :experiments, :is_internal, :boolean, :default => false
    		project_names = [ "PAF techniques", "Lorenz Weidenauer", "Severine Lorrain" ]
    		project_names.each do |project_name|
				update "UPDATE experiments INNER JOIN projects AS p ON experiments.project_id = p.id SET is_internal = 1 WHERE p.name = '#{project_name}';"
			end
  	end

	def self.down
		remove_column :experiments, :is_internal
	end
end

