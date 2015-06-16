module Static
  class Trait < StaticDatabase
    self.table_name = "dgmAttributeTypes"
    self.primary_key = "attributeID"
    has_many :item_traits, foreign_key: :attributeID
    # include ReadOnlyRecord
    alias_attribute :name, :attributeName
  end
end
