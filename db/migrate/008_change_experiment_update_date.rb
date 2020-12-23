class ChangeExperimentUpdateDate < ActiveRecord::Migration
        def self.up
                Experiment.update_all("updated_on=created_on")
        end

        def self.down
        end
end

