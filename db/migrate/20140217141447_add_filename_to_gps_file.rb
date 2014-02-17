class AddFilenameToGpsFile < ActiveRecord::Migration
  def change
    add_column :gps_files, :filename, :string
  end
end
