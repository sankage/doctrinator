class CreatePilots < ActiveRecord::Migration
  def change
    create_table :pilots do |t|
      t.string :character_id
      t.string :name
      t.belongs_to :api_key, index: true

      t.timestamps null: false
    end
    add_foreign_key :pilots, :api_keys
  end
end
