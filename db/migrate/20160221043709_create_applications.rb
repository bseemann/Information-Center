class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :expa_id
      t.string :expa_url
      #t.string :expa_matchability
      t.string :expa_status
      t.integer :expa_current_status #boolean
      #t.string :expa_favourite
      #t.string :expa_permissions
      t.timestamp :expa_created_at
      t.timestamp :expa_updated_at
      #t.string :expa_opportunity


      t.timestamps null: false
    end
  end
end
