class Requirement
  def self.create_from_static_array(static_array)
    skill_ids = static_array.map(&:first)
    skills = Static::Skill.where(typeID: skill_ids)
    static_array.map { |skill_id, level|
      skill = skills.detect { |s| s.typeID == skill_id }
      new(skill, level) unless skill.nil?
    }.uniq
  end

  def self.create_from_skill_id(id, level)
    new(Static::Skill.find(id), level)
  end

  def self.from_item_ids(item_ids)
    from_items(Static::Item.where(typeID: item_ids))
  end

  def self.from_items(items)
    # These are attribute ids for RequiredSkill entries
    requirement_attributes = [182, 183, 184, 1285, 1289, 1290]
    # These are attribute ids for RequiredSkillLevel entries
    requirement_levels = [277, 278, 279, 1286, 1287, 1288]

    item_ids = items.map(&:typeID)
    skill_ids = Static::ItemTrait.where(attributeID: requirement_attributes,
                                             typeID: item_ids).
                                  pluck(:valueInt, :valueFloat).
                                  flatten.compact.map(&:to_i)
    levels = Static::ItemTrait.where(attributeID: requirement_levels,
                                          typeID: item_ids).
                               pluck(:valueInt, :valueFloat).
                               flatten.compact.map(&:to_i)

    Requirement.create_from_static_array(skill_ids.zip(levels))
  end

  include Comparable

  attr_reader :skill_id, :skill_name, :level
  def initialize(skill, level)
    @skill_id = skill.typeID
    @skill_name = skill.typeName
    @level = level
    freeze
  end

  def <=>(other)
    return nil unless other.is_a?(self.class)
    return nil unless other.skill_id == skill_id
    other.level <=> level
  end

  def hash
    [skill_id, level, Requirement].hash
  end

  alias_method :eql?, :==
end
