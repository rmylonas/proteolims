class AddInstrumentToSamples < ActiveRecord::Migration
        def self.up
                add_column :samples, :instrument, :string, :default => ''
        end

        def self.down
                remove_column :samples, :instrument
        end
end

