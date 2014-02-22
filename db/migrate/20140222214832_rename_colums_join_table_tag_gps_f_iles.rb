class RenameColumsJoinTableTagGpsFIles < ActiveRecord::Migration
  def change
    rename_column :gps_files_tags, :gps_files, :gps_file_id
    rename_column :gps_files_tags, :tags, :tag_id
  end
end
