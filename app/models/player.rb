class Player < ActiveRecord::Base
  has_many :api_keys, dependent: :destroy
  has_many :pilots, through: :api_keys
end
