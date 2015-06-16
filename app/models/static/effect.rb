module Static
  class Effect < StaticDatabase
    self.table_name = "dgmEffects"
    self.primary_key = "effectID"
    has_many :item_effects, foreign_key: :effectID
    # include ReadOnlyRecord

    alias_attribute :name, :effectName
  end
end
