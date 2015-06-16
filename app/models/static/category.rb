module Static
  class Category < StaticDatabase
    self.table_name = "invCategories"
    self.primary_key = "categoryID"
    has_many :groups, foreign_key: :groupID
    # include ReadOnlyRecord
    alias_attribute :name, :categoryName
  end
end
