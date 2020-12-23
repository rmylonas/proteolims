class ModifySamplesAnalysisTypeLimit < ActiveRecord::Migration
  def self.up
    change_column( :samples, :analysis_type, :string, {:limit => 50} )
  end

  def self.down
    change_column( :samples, :analysis_type, :string, {:limit => 20} )
  end
end
