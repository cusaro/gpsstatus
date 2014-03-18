class AddStatisticToGpsfiles < ActiveRecord::Migration
  def change
    add_column :gps_files,:statistic,:boolean
  end
end
