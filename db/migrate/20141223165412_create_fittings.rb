class CreateFittings < ActiveRecord::Migration
  def change
    create_table :fittings do |t|
      t.string :name
      t.string :ship_name
      t.string :dna
      t.text :eft
      t.string :requirement_dna

      t.timestamps null: false
    end
  end
end
