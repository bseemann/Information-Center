class CreateRdControls < ActiveRecord::Migration
  def change
    create_table :rd_controls do |t|

      t.timestamps null: false
    end
  end
end
