module Static
  class ItemTrait < StaticDatabase
    self.table_name = "dgmTypeAttributes"
    self.primary_keys = "typeID", "attributeID"
    belongs_to :item, foreign_key: :typeID
    belongs_to :trait, foreign_key: :attributeID
    include ReadOnlyRecord

  end
end
