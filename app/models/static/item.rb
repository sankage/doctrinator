module Static
  class Item < StaticDatabase
    self.table_name = "invTypes"
    self.primary_key = "typeID"
    belongs_to :group, foreign_key: :groupID
    has_many :item_effects, foreign_key: :typeID
    has_many :effects, through: :item_effects
    has_many :item_traits, foreign_key: :typeID
    has_many :traits, through: :item_traits
    # include ReadOnlyRecord

    alias_attribute :name, :typeName

    def name
      typeName
    end

    def requirements
      Requirement.from_items([self])
    end

    def category
      group.category
    end
  end
end


# SELECT
# Ships.typeName AS ShipName,
# Grouping.groupName AS ShipType,
# Skills.typeName AS RequiredSkill,
# COALESCE(SkillLevel.valueInt, SkillLevel.valueFloat) AS RequiredLevel
# FROM
# dgmTypeAttributes AS SkillName
# INNER JOIN invTypes AS Ships
#   ON Ships.typeID = SkillName.typeID
# INNER JOIN invGroups AS Grouping
#   ON Grouping.groupID = Ships.groupID
# INNER JOIN invTypes AS Skills
#   ON  (Skills.typeID = SkillName.valueInt OR Skills.typeID = SkillName.valueFloat)
#   AND SkillName.attributeID IN (182, 183, 184, 1285, 1289, 1290)
# INNER JOIN dgmTypeAttributes AS SkillLevel
#   ON  SkillLevel.typeID = SkillName.typeID
#   AND SkillLevel.attributeID IN (277, 278, 279, 1286, 1287, 1288)
# WHERE Ships.published = 1
#   AND (
#        (SkillName.attributeID = 182 AND SkillLevel.attributeID = 277)
#     OR (SkillName.attributeID = 183 AND SkillLevel.attributeID = 278)
#     OR (SkillName.attributeID = 184 AND SkillLevel.attributeID = 279)
#     OR (SkillName.attributeID = 1285 AND SkillLevel.attributeID = 1286)
#     OR (SkillName.attributeID = 1289 AND SkillLevel.attributeID = 1287)
#     OR (SkillName.attributeID = 1290 AND SkillLevel.attributeID = 1288))
#   AND Ships.typeID = 377
