module Static
  class Module < Item
    default_scope -> { joins(:group).where(invGroups: { categoryID: 7 }, published: true) }

  end
end
