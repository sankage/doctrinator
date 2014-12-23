module Static
  class Drone < Item
    default_scope -> { joins(:group).where(invGroups: { categoryID: 18 }, published: true) }

  end
end
