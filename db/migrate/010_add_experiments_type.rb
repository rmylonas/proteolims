class AddExperimentsType < ActiveRecord::Migration
	def self.up
    		add_column :experiments, :exp_type, :integer, :default => 0
    		update "UPDATE experiments SET exp_type=is_internal"

    		project_names = [ "Severine Lorrain" ]
    		project_names.each do |project_name|
				update "UPDATE experiments INNER JOIN projects AS p ON experiments.project_id = p.id SET exp_type = 2 WHERE p.name = '#{project_name}';"
			end

			remove_column :experiments, :is_internal
  	end

	def self.down
		remove_column :experiments, :exp_type
	end
end

