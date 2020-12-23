class AddStatusToExperiments < ActiveRecord::Migration
	def self.up
    		add_column :experiments, :status, :integer, :default => 0
  	end

	def self.down
		remove_column :experiments, :status
	end
end

