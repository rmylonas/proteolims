class AddFilepathToUploads < ActiveRecord::Migration
  def self.up
		add_column :uploads, :filepath, :string
  end

  def self.down
		remove_column :uploads, :filepath
  end
end
