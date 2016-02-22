class CreateExpaApplications < ActiveRecord::Migration
  def change
    create_table :expa_applications do |t|
      t.integer :xp_id
      t.string :xp_url
      #t.string :xp_matchability
      t.integer :xp_status #Enum (From String to Enum)
      t.integer :xp_current_status #Enum (From String to Enum)
      #t.string :xp_favourite
      #t.string :xp_permissions
      t.timestamp :xp_created_at
      t.timestamp :xp_updated_at
      #t.string :xp_opportunity

      t.timestamps null: false
    end
  end
end
