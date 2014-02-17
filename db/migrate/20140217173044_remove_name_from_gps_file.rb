class RemoveNameFromGpsFile < ActiveRecord::Migration
  def change
    remove_column :gps_files, :name
  end
end
