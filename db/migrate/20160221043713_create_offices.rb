class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.integer :expa_id
      t.string :expa_name
      t.string :expa_full_name
      t.string :expa_url

      t.timestamps null: false
    end
  end
end
