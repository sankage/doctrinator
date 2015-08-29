class AddAccessLevelToPilots < ActiveRecord::Migration
  def change
    add_column :pilots, :access_level, :integer, default: 0
  end
end
