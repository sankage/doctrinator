class Doctrine < ActiveRecord::Base
  has_and_belongs_to_many :fittings, join_table: :doctrine_fits
end
