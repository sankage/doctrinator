class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :key_id
      t.string :v_code
      t.belongs_to :player, index: true

      t.timestamps null: false
    end
    add_foreign_key :api_keys, :players
  end
end
