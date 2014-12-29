class CreateDoctrines < ActiveRecord::Migration
  def change
    create_table :doctrines do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
