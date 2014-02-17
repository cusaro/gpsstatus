class CreateGpsFiles < ActiveRecord::Migration
  def change
    create_table :gps_files do |t|
      t.float :duration
      t.float :length
      t.float :average_speed
      t.datetime :start
      t.datetime :end
      t.string :image
      t.string :name

      t.timestamps
    end
  end
end
