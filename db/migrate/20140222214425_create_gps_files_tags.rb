class CreateGpsFilesTags < ActiveRecord::Migration
  def change
    create_table :gps_files_tags do |t|
      t.integer :gps_files
      t.integer :tags

      t.timestamps
    end
  end
end
