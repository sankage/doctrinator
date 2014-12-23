class CreatePilotSkills < ActiveRecord::Migration
  def change
    create_table :pilot_skills do |t|
      t.belongs_to :pilot, index: true
      t.integer :skill_id
      t.integer :level

      t.timestamps null: false
    end
    add_foreign_key :pilot_skills, :pilots
  end
end
