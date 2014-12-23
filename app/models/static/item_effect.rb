module Static
  class ItemEffect < StaticDatabase
    self.table_name = "dgmTypeEffects"
    self.primary_keys = "typeID", "effectID"
    belongs_to :effect, foreign_key: :effectID
    belongs_to :item, foreign_key: :typeID
    include ReadOnlyRecord
  end
end
