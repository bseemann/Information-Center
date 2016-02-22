class CreateExpaOffices < ActiveRecord::Migration
  def change
    create_table :expa_offices do |t|
      t.integer :xp_id
      t.string :xp_name
      t.string :xp_full_name
      t.string :xp_url

      t.timestamps null: false
    end
  end
end
