class PilotSkill < ActiveRecord::Base
  def self.import_for_pilot(pilot)
    api = EAAL::API.new(pilot.api_key.key_id, pilot.api_key.v_code, "char")
    result = api.CharacterSheet(characterID: pilot.character_id)
    skills = parse_skills(skills: result.skills, pilot: pilot)

    PilotSkill.import(skills)
    pilot.touch
  end

  def self.parse_skills(skills: , pilot:)
    skill_ids = skills.map(&:typeID)
    skill_data = Static::Skill.includes(:group).find(skill_ids)
    pilot_skills = pilot.pilot_skills
    skills.map do |data|
      skill = skill_data.detect { |s| s.typeID.to_i == data.typeID.to_i }
      next unless skill
      skill_model = pilot_skills.detect { |s| s.skill_id == skill.id }
      if skill_model.nil?
        skill_model = new(pilot_id: pilot.id, skill_id: skill.typeID, level: data.level.to_i)
        next skill_model
      end

      if skill_model.level.to_i != data.level.to_i
        skill_model.update(level: data.level)
      end
      next
    end.compact
  end

  # TODO: Upon request, if the pilot hasnt been modified in the last 12 hours, trigger a new
  # import to happen in the background

  belongs_to :pilot, touch: true
  belongs_to :skill, :class_name => "Static::Skill", foreign_key: :skill_id
end
