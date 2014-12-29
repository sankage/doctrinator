class CreateDoctrineFits < ActiveRecord::Migration
  def change
    create_table :doctrine_fits do |t|
      t.belongs_to :doctrine, index: true
      t.belongs_to :fitting, index: true

      t.timestamps null: false
    end
    add_foreign_key :doctrine_fits, :doctrines
    add_foreign_key :doctrine_fits, :fittings
  end
end
