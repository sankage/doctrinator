module Static
  class Group < StaticDatabase
    self.table_name = "invGroups"
    self.primary_key = "groupID"
    belongs_to :category, foreign_key: :categoryID
    include ReadOnlyRecord

    alias_attribute :name, :groupName
  end
end
