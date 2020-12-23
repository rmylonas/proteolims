class AddInjectionToSamples < ActiveRecord::Migration
        def self.up
                add_column :samples, :injection, :string, :default => ''
        end

        def self.down
                remove_column :samples, :injection
        end
end