class AddPrimeToPilots < ActiveRecord::Migration
  def change
    add_column :pilots, :prime, :boolean, default: false
  end
end
