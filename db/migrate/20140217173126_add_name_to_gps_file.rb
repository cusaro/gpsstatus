class AddNameToGpsFile < ActiveRecord::Migration
  def change
    add_column :gps_files, :name, :string
  end
end
