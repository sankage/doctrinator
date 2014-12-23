module Static
  class Implant < Item
    default_scope -> { joins(:group).where(invGroups: { categoryID: 20 }, published: true) }

  end
end
