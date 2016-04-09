class AddPublicField < ActiveRecord::Migration
  def change
  	add_column :archives, :public, :boolean, default: false
  end
end
