class SetDefaultForStatisticInGpsFiles < ActiveRecord::Migration
  def change
    change_column_default :gps_files, :statistic, true
  end
end
