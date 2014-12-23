module Static
  class Charge < Item
    default_scope -> { joins(:group).where(invGroups: { categoryID: 8 }, published: true) }

  end
end
