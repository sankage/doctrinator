class ApiKey < ActiveRecord::Base
  belongs_to :player
  has_many :pilots
end
