class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :expa_id
      t.string :expa_url
      t.string :expa_matchability
      t.string :expa_status
      t.string :expa_current_status
      t.string :expa_favourite
      t.string :expa_permissions
      t.string :expa_created_at
      t.string :expa_updated_at
      t.string :expa_opportunity


      t.timestamps null: false
    end
  end
end
