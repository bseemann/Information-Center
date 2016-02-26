class CreateExpaApplications < ActiveRecord::Migration
  def change
    create_table :expa_applications do |t|
      t.column :xp_id, :integer
      t.column :xp_url, :string
      #t.column :matchability :string
      t.column :xp_status, :integer #enum
      t.column :xp_current_status, :integer #enum
      #t.column :xp_favourite, :string
      #t.column :xp_permissions, :string
      t.column :xp_created_at, :timestamp
      t.column :xp_updated_at, :timestamp
      #t.column :xp_opportunity, : string

      t.timestamps null: false
    end
  end
end
