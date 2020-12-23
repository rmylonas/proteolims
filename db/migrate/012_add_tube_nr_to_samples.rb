class AddTubeNrToSamples < ActiveRecord::Migration
        def self.up
                add_column :samples, :tube, :integer, :default => 0
        end

        def self.down
                remove_column :samples, :tube
        end
end