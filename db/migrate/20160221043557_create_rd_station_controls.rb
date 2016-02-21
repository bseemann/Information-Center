class CreateRdStationControls < ActiveRecord::Migration
  def change
    create_table :rd_station_controls do |t|

      t.timestamps null: false
    end
  end
end
