module Static
  class Skill < Item
    default_scope -> { joins(:group).where(invGroups: { categoryID: 16 }, published: true) }

    def group_name
      group.name
    end
  end
end
