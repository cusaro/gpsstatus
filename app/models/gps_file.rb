class GpsFile < ActiveRecord::Base
  has_attached_file :image, :styles => { :big => '800x800', :thumb => '200x200'}
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)

  has_and_belongs_to_many :tags
end
