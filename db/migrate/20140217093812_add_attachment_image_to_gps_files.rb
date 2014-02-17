class AddAttachmentImageToGpsFiles < ActiveRecord::Migration
  def self.up
    change_table :gps_files do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :gps_files, :image
  end
end
