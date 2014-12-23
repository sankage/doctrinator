class Player < ActiveRecord::Base
  has_many :api_keys
  has_many :pilots, through: :api_keys
end
