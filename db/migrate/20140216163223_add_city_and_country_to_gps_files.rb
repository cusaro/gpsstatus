class AddCityAndCountryToGpsFiles < ActiveRecord::Migration
  def change
    add_column :gps_files, :city, :string
    add_column :gps_files, :country, :string
  end
end
