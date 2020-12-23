class AddBillDoneToExperiments < ActiveRecord::Migration
	def self.up
    		add_column :experiments, :bill_done, :boolean, :default => false
  	end

	def self.down
		remove_column :experiments, :bill_done
	end
end

