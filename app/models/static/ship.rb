module Static
  class Ship < Item
    default_scope -> { joins(:group).where(invGroups: { categoryID: 6 }, published: true) }

    def type
      group.groupName
    end
  end
end
